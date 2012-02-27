alias echo='builtin echo'
function ok() {
  json="$1"
  expected="$(echo)$(echo -E "$2")"
  results="$(echo && echo -E "$json" | ./jason && echo)"
  if [[ "$expected" == "$results" ]]; then
    echo "OK ${test}"
  else
    echo "NOT OK ${test}"
    echo "  DIFF:"
    diff -y <(echo -E "$expected") <(echo -$ "$results")
    exit 1
  fi
}



test="Empty Hash"
ok '{}' '
this	{ }
'

test="Empty Array"
ok '[]' '
this	[ ]
'

test="Array of Values"
ok '[ 1, 2.3, "foo", "bar \"baz\" bing" ]' '
this[0]	1
this[1]	2.3
this[2]	"foo"
this[3]	"bar \"baz\" bing"
this	[ 1, 2.3, "foo", "bar \"baz\" bing" ]
'

test="Nested Arrays"
ok '[[[[[[[[[[[[["Not too deep"]]]]]]]]]]]]]' '
this[0][0][0][0][0][0][0][0][0][0][0][0][0]	"Not too deep"
this[0][0][0][0][0][0][0][0][0][0][0][0]	[ "Not too deep" ]
this[0][0][0][0][0][0][0][0][0][0][0]	[ [ "Not too deep" ] ]
this[0][0][0][0][0][0][0][0][0][0]	[ [ [ "Not too deep" ] ] ]
this[0][0][0][0][0][0][0][0][0]	[ [ [ [ "Not too deep" ] ] ] ]
this[0][0][0][0][0][0][0][0]	[ [ [ [ [ "Not too deep" ] ] ] ] ]
this[0][0][0][0][0][0][0]	[ [ [ [ [ [ "Not too deep" ] ] ] ] ] ]
this[0][0][0][0][0][0]	[ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ]
this[0][0][0][0][0]	[ [ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ] ]
this[0][0][0][0]	[ [ [ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ] ] ]
this[0][0][0]	[ [ [ [ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ] ] ] ]
this[0][0]	[ [ [ [ [ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ] ] ] ] ]
this[0]	[ [ [ [ [ [ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ] ] ] ] ] ]
this	[ [ [ [ [ [ [ [ [ [ [ [ [ "Not too deep" ] ] ] ] ] ] ] ] ] ] ] ] ]
'

test="Nested Hashes"
ok '{"JSON Test Pattern pass3":{"The outermost value":"must be an object or array.","In this test":"It is an object."}}' '
this["JSON Test Pattern pass3"]["The outermost value"]	"must be an object or array."
this["JSON Test Pattern pass3"]["In this test"]	"It is an object."
this["JSON Test Pattern pass3"]	{ "The outermost value": "must be an object or array.", "In this test": "It is an object." }
this	{ "JSON Test Pattern pass3": { "The outermost value": "must be an object or array.", "In this test": "It is an object." } }
'

test="Complex Data"
ok "$(cat ./complex.json)" '
this[0]	"JSON Test Pattern pass1"
this[1]["object with 1 member"][0]	"array with 1 element"
this[1]["object with 1 member"]	[ "array with 1 element" ]
this[1]	{ "object with 1 member": [ "array with 1 element" ] }
this[2]	{ }
this[3]	[ ]
this[4]	-42
this[5]	true
this[6]	false
this[7]	null
this[8]["integer"]	1234567890
this[8]["real"]	-9876.543210
this[8]["e"]	0.123456789e-12
this[8]["E"]	1.234567890E+34
this[8][""]	23456789012E66
this[8]["zero"]	0
this[8]["one"]	1
this[8]["space"]	" "
this[8]["quote"]	"\""
this[8]["backslash"]	"\\"
this[8]["controls"]	"\b\f\n\r\t"
this[8]["slash"]	"/ & \/"
this[8]["alpha"]	"abcdefghijklmnopqrstuvwyz"
this[8]["ALPHA"]	"ABCDEFGHIJKLMNOPQRSTUVWYZ"
this[8]["digit"]	"0123456789"
this[8]["0123456789"]	"digit"
this[8]["special"]	"`1~!@#$%^&*()_+-={'\'':[,]}|;.</>?"
this[8]["hex"]	"\u0123\u4567\u89AB\uCDEF\uabcd\uef4A"
this[8]["true"]	true
this[8]["false"]	false
this[8]["null"]	null
this[8]["array"]	[ ]
this[8]["object"]	{ }
this[8]["address"]	"50 St. James Street"
this[8]["url"]	"http://www.JSON.org/"
this[8]["comment"]	"// /* <!-- --"
this[8]["# -- --> */"]	" "
this[8][" s p a c e d "][0]	1
this[8][" s p a c e d "][1]	2
this[8][" s p a c e d "][2]	3
this[8][" s p a c e d "][3]	4
this[8][" s p a c e d "][4]	5
this[8][" s p a c e d "][5]	6
this[8][" s p a c e d "][6]	7
this[8][" s p a c e d "]	[ 1, 2, 3, 4, 5, 6, 7 ]
this[8]["compact"][0]	1
this[8]["compact"][1]	2
this[8]["compact"][2]	3
this[8]["compact"][3]	4
this[8]["compact"][4]	5
this[8]["compact"][5]	6
this[8]["compact"][6]	7
this[8]["compact"]	[ 1, 2, 3, 4, 5, 6, 7 ]
this[8]["jsontext"]	"{\"object with 1 member\":[\"array with 1 element\"]}"
this[8]["quotes"]	"&#34; \u0022 %22 0x22 034 &#x22;"
this[8]["\/\\\"\uCAFE\uBABE\uAB98\uFCDE\ubcda\uef4A\b\f\n\r\t`1~!@#$%^&*()_+-=[]{}|;:'\'',./<>?"]	"A key can be any string"
this[8]	{ "integer": 1234567890, "real": -9876.543210, "e": 0.123456789e-12, "E": 1.234567890E+34, "": 23456789012E66, "zero": 0, "one": 1, "space": " ", "quote": "\"", "backslash": "\\", "controls": "\b\f\n\r\t", "slash": "/ & \/", "alpha": "abcdefghijklmnopqrstuvwyz", "ALPHA": "ABCDEFGHIJKLMNOPQRSTUVWYZ", "digit": "0123456789", "0123456789": "digit", "special": "`1~!@#$%^&*()_+-={'\'':[,]}|;.</>?", "hex": "\u0123\u4567\u89AB\uCDEF\uabcd\uef4A", "true": true, "false": false, "null": null, "array": [ ], "object": { }, "address": "50 St. James Street", "url": "http://www.JSON.org/", "comment": "// /* <!-- --", "# -- --> */": " ", " s p a c e d ": [ 1, 2, 3, 4, 5, 6, 7 ], "compact": [ 1, 2, 3, 4, 5, 6, 7 ], "jsontext": "{\"object with 1 member\":[\"array with 1 element\"]}", "quotes": "&#34; \u0022 %22 0x22 034 &#x22;", "\/\\\"\uCAFE\uBABE\uAB98\uFCDE\ubcda\uef4A\b\f\n\r\t`1~!@#$%^&*()_+-=[]{}|;:'\'',./<>?": "A key can be any string" }
this[9]	0.5
this[10]	98.6
this[11]	99.44
this[12]	1066
this[13]	1e1
this[14]	0.1e1
this[15]	1e-1
this[16]	1e00
this[17]	2e+00
this[18]	2e-00
this[19]	"rosebud"
this	[ "JSON Test Pattern pass1", { "object with 1 member": [ "array with 1 element" ] }, { }, [ ], -42, true, false, null, { "integer": 1234567890, "real": -9876.543210, "e": 0.123456789e-12, "E": 1.234567890E+34, "": 23456789012E66, "zero": 0, "one": 1, "space": " ", "quote": "\"", "backslash": "\\", "controls": "\b\f\n\r\t", "slash": "/ & \/", "alpha": "abcdefghijklmnopqrstuvwyz", "ALPHA": "ABCDEFGHIJKLMNOPQRSTUVWYZ", "digit": "0123456789", "0123456789": "digit", "special": "`1~!@#$%^&*()_+-={'\'':[,]}|;.</>?", "hex": "\u0123\u4567\u89AB\uCDEF\uabcd\uef4A", "true": true, "false": false, "null": null, "array": [ ], "object": { }, "address": "50 St. James Street", "url": "http://www.JSON.org/", "comment": "// /* <!-- --", "# -- --> */": " ", " s p a c e d ": [ 1, 2, 3, 4, 5, 6, 7 ], "compact": [ 1, 2, 3, 4, 5, 6, 7 ], "jsontext": "{\"object with 1 member\":[\"array with 1 element\"]}", "quotes": "&#34; \u0022 %22 0x22 034 &#x22;", "\/\\\"\uCAFE\uBABE\uAB98\uFCDE\ubcda\uef4A\b\f\n\r\t`1~!@#$%^&*()_+-=[]{}|;:'\'',./<>?": "A key can be any string" }, 0.5, 98.6, 99.44, 1066, 1e1, 0.1e1, 1e-1, 1e00, 2e+00, 2e-00, "rosebud" ]
'