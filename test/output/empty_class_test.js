require("test_helper");
var EmptyClassTest = Class.create(ActiveSupport.TestCase,
	{
		"setup": function($super) {
			RubyJS.Translator.load_file(File.join(RubyJS.test_path(),
					"unit/mock"),
				"empty_class_test.rb");
			this.class_translator = RubyJS.Translator(EmptyClass);
			this.test_translator = RubyJS.Translator(EmptyClassTest);
		},
		test_produces_a_Ruby_class: function() {
			assert(EmptyClass.is_kind_of(Class))
		},
		test_produces_a_JS_class: function() {
			var fi;
			File.open(fi = File.join(File.dirname("C:/projects/rubyjs/test/unit/mock/empty_class_test.rb"),
					"../../output/empty_class.js"),
				"w",
				function(f,
					b) {
					f.puts(@class_translator.to_s())
				});
			puts(File.read(fi));
			puts();
		},
		test_produces_a_JS_unit_test: function() {
			var r,
			fi;
			document.DEBUG = true;
			r = this.test_translator.to_s();
			File.open(fi = File.join(File.dirname("C:/projects/rubyjs/test/unit/mock/empty_class_test.rb"),
					"../../output/empty_class_test.js"),
				"w",
				function(f,
					b) {
					f.puts(new RubyJS.Javascript.Unpacker(r))
				});
			puts(r);
			puts();
			document.DEBUG = false;
		}
	});
;
