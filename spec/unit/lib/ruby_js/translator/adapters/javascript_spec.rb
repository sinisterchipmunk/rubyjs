require 'spec_helper'

describe RubyJS::Translator::Adapters::Javascript do
  def process(code)
    sexp = code.kind_of?(Array) ? code : RubyParser.new.parse(code).to_a
    RubyJS::Translator::Adapters::Javascript.new(sexp).result
  end

  it "#javascript_name_for class variable" do
    RubyJS::Translator::Adapters::Javascript.new('class EmptyClass; end').javascript_name_for("@@class_variable").
            should == 'EmptyClass.class_variable'
  end

  it "#javascript_for_true returns 'true'" do
    process([:true]).should == 'true'
  end

  it "#javascript_for_true returns 'false'" do
    process([:false]).should == 'false'
  end

  it "#javascript_for_gasgn constructs a global variable assignment" do
    process([:gasgn, :$global_variable, [:lvar, :varname]]).should == 'document.global_variable = varname'
  end

  it "#javascript_for_iasgn constructs an instance variable assignment" do
    process([:iasgn, :@instance_variable, [:lvar, :varname]]).should == 'this.instance_variable = varname'
  end

  it "#javascript_from_ivar constructs an instance variable reference" do
    process([:ivar, :@instance_variable]).should == "this.instance_variable"
  end

  it "produces an empty ruby_js class" do
    code = "class EmptyClass; end"
    process(code).should == "var EmptyClass = Class.create({  });"
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
    process(code).should == 'callmethod("description", function() {  })'
  end

  it "instantiate a class" do
    code = "Class.new"
    process(code).should == 'new Class()'
  end

  it "a unit test" do
    code = "class T; test 'the truth' do; assert true; end; end"
    process(code).should == 'var T = Class.create({ test_the_truth: function() { assert(true) } });'
  end

  it "#javascript_for_masgn constructs method arguments" do
    process([:masgn, [:array, [:lasgn, :a], [:lasgn, :b]]]).should == 'a, b'
  end

  it "#javascript_for_lasgn constructs variable assignment" do
    process([:lasgn, :a, [:lvar, :b]]).should == 'a = b'
  end
end
