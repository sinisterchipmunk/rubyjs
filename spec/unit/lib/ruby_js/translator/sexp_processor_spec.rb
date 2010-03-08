require 'spec_helper'

describe RubyJS::Translator::SexpProcessor do
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