alias echo='builtin echo'
function ok() {
  json='{ "users": [ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ] }'
  expected="$(echo)$(echo -E "$2")"
  results="$(echo && echo -E "$json" | ./$1 && echo)"
  if [[ "$expected" == "$results" ]]; then
    echo "OK ${test}"
  else
    echo "NOT OK ${test}"
    echo "  DIFF:"
    diff -y <(echo -E "$expected") <(echo -$ "$results")
    exit 1
  fi
}

test="Empty Search"
ok 'jason' '
this["users"][0]["name"]	"Amy"
this["users"][0]["age"]	12
this["users"][0]	{ "name": "Amy", "age": 12 }
this["users"][1]["name"]	"Bill"
this["users"][1]["age"]	42
this["users"][1]	{ "name": "Bill", "age": 42 }
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]
this	{ "users": [ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ] }
'

test="Anchored Search"
ok 'jason this.users' '
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]
'

test="Unanchored Search"
ok 'jason users' '
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]
'

test="Anchor with Subscript"
ok 'jason this["users"]' '
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]
'
 
test="Map Operator"
ok 'jason users:name' '
this["users"][0]["name"]	"Amy"
this["users"][1]["name"]	"Bill"
'

test="Asterisk"
ok 'jason users[*][*]' '
this["users"][0]["name"]	"Amy"
this["users"][0]["age"]	12
this["users"][1]["name"]	"Bill"
this["users"][1]["age"]	42
'
