require 'spec_helper'

describe RubyJS::Translator::SexpProcessor do
  def process(code)
    RubyJS::Translator::SexpProcessor.new(RubyParser.new.parse(code).to_a).to_javascript
  end

  it "produces an empty ruby_js class" do
    code = "class EmptyClass; end"
    process(code).should == "var EmptyClass = Class.create({ });"
  end

  it "simple call" do
    code = "callmethod"
    process(code).should == "callmethod()"
  end

  it "2 simple calls" do
    code = "callmethod1; callmethod2"
    process(code).should == "callmethod1(); callmethod2();"
  end

  it "call with block" do
    code = "callmethod 'description' do\nend"
    process(code).should == 'callmethod("description", function() { })'
  end

  it "instantiate a class" do
    code = "Class.new"
    process(code).should == 'new Class()'
  end

  it "a unit test" do
    code = "class T; test 'the truth' do; assert true; end; end"
    process(code).should == 'var T = Class.create({ test_the_truth: function() { assert(true) } });'
  end

  context "private methods" do
    before(:each) do
      @processor = RubyJS::Translator::SexpProcessor.new('class EmptyClass < Superclass; end')
      @processor.to_javascript
    end
    
    it "translates class variables" do
      @processor.send(:javascript_name_for, '@@class_var').should == 'EmptyClass.class_var'
    end

    it "translates instance variables" do
      @processor.send(:javascript_name_for, '@instance_var').should == 'this.instance_var'
    end

    it "finds superclass name" do
      @processor.send(:superclass_name).should == 'Superclass'
    end
  end

  it "constructs method arguments" do
    @processor = RubyJS::Translator::SexpProcessor.new([:masgn, [:array, [:lasgn, :a], [:lasgn, :b]]])
    @processor.to_javascript.should == 'a, b'
  end

  it "constructs variable assignment" do
    @processor = RubyJS::Translator::SexpProcessor.new [:lasgn, :a, [:lvar, :b]]
    @processor.to_javascript.should == 'a = b'
  end

  it "call" do
    p = RubyJS::Translator::SexpProcessor.new([:call,
                                                   [:colon2, [:const, :Javascript], :Translator],
                                                   :load_file,
                                                   [:arglist,
                                                    [:call,
                                                     [:const, :File],
                                                     :join,
                                                     [:arglist,
                                                      [:gvar, :$JAVASCRIPT_MODELS_PATH],
                                                      [:str, "test/support/mock"]
                                                    ]],
                                                    [:str, "empty_class.rb"]
                                                  ]])
    p.to_javascript.should ==
            'Javascript.Translator.load_file(File.join(document.JAVASCRIPT_MODELS_PATH, "test/support/mock"), "empty_class.rb")'
  end

  it "arglist containing a call" do
    p = RubyJS::Translator::SexpProcessor.new [:arglist,
                                                    [:call,
                                                     [:const, :File],
                                                     :join,
                                                     [:arglist,
                                                      [:gvar, :$JAVASCRIPT_MODELS_PATH],
                                                      [:str, "test/support/mock"]
                                                    ]],
                                                    [:str, "empty_class.rb"]
                                                  ]
    p.to_javascript.should == '(File.join(document.JAVASCRIPT_MODELS_PATH, "test/support/mock"), "empty_class.rb")'
  end

  it "call class method with 1 argument" do
    p = RubyJS::Translator::SexpProcessor.new [:call,
                                                   [:const, :File],
                                                   :join,
                                                   [:arglist,
                                                    [:gvar, :$JAVASCRIPT_MODELS_PATH],
                                                    [:str, "test/support/mock"]
                                                  ]]
    p.to_javascript.should == 'File.join(document.JAVASCRIPT_MODELS_PATH, "test/support/mock")'
  end

  it "produces a ruby_js class with one function call in one function" do
    p = RubyJS::Translator::SexpProcessor.new([:class, :MyKlass, nil,
                                                   [:scope,
                                                    [:defn, :say_hello, [:args], [:scope,
                                                      [:block,
                                                       [:call, nil, :puts,
                                                        [:arglist, [:str, "hi"]
                                                  ]]]]]]])
    p.to_javascript.should == 'var MyKlass = Class.create({ "say_hello": function($super) { puts("hi"); } });'
  end

  it "produces a ruby_js class with two function calls in one function" do
    p = RubyJS::Translator::SexpProcessor.new([:class, :MyKlass, nil,
                                                   [:scope,
                                                    [:defn, :say_hello, [:args], [:scope,
                                                     [:block,
                                                      [:call, nil, :puts,
                                                       [:arglist, [:str, "hi"]
                                                      ]],
                                                      [:call, nil, :puts,
                                                       [:arglist, [:str, "ho"]
                                                  ]]]]]]])
    p.to_javascript.should ==
            'var MyKlass = Class.create({ "say_hello": function($super) { puts("hi"); puts("ho"); } });'
  end

  it "produces a ruby_js class with one function calls in each of two functions" do
    p = RubyJS::Translator::SexpProcessor.new([:class, :MyKlass, nil,
                                                   [:scope,
                                                    [:block,
                                                     [:defn, :say_hello, [:args],
                                                      [:scope,
                                                       [:block,
                                                        [:call, nil, :puts,
                                                         [:arglist,
                                                          [:str, "Hi there!"]
                                                     ]]]]],
                                                     [:defn, :say_goodbye, [:args],
                                                      [:scope,
                                                       [:block,
                                                        [:call, nil, :puts,
                                                         [:arglist, [:str, "Goodbye!"]]
                                                  ]]]]]]])
    p.to_javascript.should == 'var MyKlass = Class.create({ "say_hello": function($super) { puts("Hi there!"); }, "say_goodbye": function($super) { puts("Goodbye!"); } });'
  end
end