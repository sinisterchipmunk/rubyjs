require 'test_helper'

class Javascript::Translator::SexpProcessorTest < ActiveSupport::TestCase
  def process(code)
    Javascript::Translator::SexpProcessor.new(RubyParser.new.parse(code).to_a).to_javascript
  end

  test "produces an empty javascript class" do
    p = Javascript::Translator::SexpProcessor.new([:class, :EmptyClass, nil, [:scope]])
    assert_equal "var EmptyClass = Class.create({ });", p.to_javascript
  end

  test "simple call" do
    code = "callmethod"
    assert_equal "callmethod()", process(code)
  end

  test "2 simple calls" do
    code = "callmethod1; callmethod2"
    assert_equal "callmethod1(); callmethod2();", process(code)
  end

  test "call with block" do
    code = "callmethod 'description' do\nend"
    assert_equal 'callmethod("description", function() { })', process(code)
  end

  test "instantiate a class" do
    code = "Class.new"
    assert_equal 'new Class()', process(code)
  end

  test "a unit test" do
    code = "class T; test 'the truth' do; assert true; end; end"
    assert_equal 'var T = Class.create({ test_the_truth: function() { assert(true) } });', process(code)
  end

  test "call" do
    p = Javascript::Translator::SexpProcessor.new([:call,
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
    assert_equal 'Javascript.Translator.load_file(File.join(document.JAVASCRIPT_MODELS_PATH, "test/support/mock"), "empty_class.rb")',
                 p.to_javascript
  end

  test "arglist containing a call" do
    p = Javascript::Translator::SexpProcessor.new [:arglist,
                                                    [:call,
                                                     [:const, :File],
                                                     :join,
                                                     [:arglist,
                                                      [:gvar, :$JAVASCRIPT_MODELS_PATH],
                                                      [:str, "test/support/mock"]
                                                    ]],
                                                    [:str, "empty_class.rb"]
                                                  ]
    assert_equal '(File.join(document.JAVASCRIPT_MODELS_PATH, "test/support/mock"), "empty_class.rb")', p.to_javascript
  end

  test "call class method with 1 argument" do
    p = Javascript::Translator::SexpProcessor.new [:call,
                                                   [:const, :File],
                                                   :join,
                                                   [:arglist,
                                                    [:gvar, :$JAVASCRIPT_MODELS_PATH],
                                                    [:str, "test/support/mock"]
                                                  ]]
    assert_equal 'File.join(document.JAVASCRIPT_MODELS_PATH, "test/support/mock")', p.to_javascript
  end

  test "produces a javascript class with one function call in one function" do
    p = Javascript::Translator::SexpProcessor.new([:class, :MyKlass, nil,
                                                   [:scope,
                                                    [:defn, :say_hello, [:args], [:scope,
                                                      [:block,
                                                       [:call, nil, :puts,
                                                        [:arglist, [:str, "hi"]
                                                  ]]]]]]])
    assert_equal 'var MyKlass = Class.create({ "say_hello": function($super) { puts("hi"); } });',
                 p.to_javascript
  end

  test "produces a javascript class with two function calls in one function" do
    p = Javascript::Translator::SexpProcessor.new([:class, :MyKlass, nil,
                                                   [:scope,
                                                    [:defn, :say_hello, [:args], [:scope,
                                                     [:block,
                                                      [:call, nil, :puts,
                                                       [:arglist, [:str, "hi"]
                                                      ]],
                                                      [:call, nil, :puts,
                                                       [:arglist, [:str, "ho"]
                                                  ]]]]]]])
    assert_equal 'var MyKlass = Class.create({ "say_hello": function($super) { puts("hi"); puts("ho"); } });',
                 p.to_javascript
  end

  test "produces a javascript class with one function calls in each of two functions" do
    p = Javascript::Translator::SexpProcessor.new([:class, :MyKlass, nil,
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
    assert_equal 'var MyKlass = Class.create({ "say_hello": function($super) { puts("Hi there!"); }, "say_goodbye": function($super) { puts("Goodbye!"); } });',
                 p.to_javascript
  end
end
