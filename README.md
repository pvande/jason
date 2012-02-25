## Jason

### What

A command-line JSON parser written entirely in Bash (v3).

### Why

To provide a portable JSON parser for use as a part of a shell pipeline.

### How

``` bash
$ json='{ "users": [ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ] }'

# By default, Jason prints every key and value (tab separated) in a depth-first
# post-traversal order.
$ echo $json | jason
this["users"][0]["name"]	"Amy"
this["users"][0]["age"]	12
this["users"][0]	{ "name": "Amy", "age": 12 }
this["users"][1]["name"]	"Bill"
this["users"][1]["age"]	42
this["users"][1]	{ "name": "Bill", "age": 42 }
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]
this	{ "users": [ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ] }

# Jason can also accept a search path, which will limit the output to only keys
# matching the given keypath.
$ echo $json | jason this.users
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]

# Jason is reasonably flexible about the form of your keypath.
$ echo $json | jason users
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]
$ echo $json | jason 'this["users"]'
this["users"]	[ { "name": "Amy", "age": 12 }, { "name": "Bill", "age": 42 } ]

# The ':' operator lets you quickly map over arrays and hashes.
$ echo $json | jason users:name
this["users"][0]["name"]	"Amy"
this["users"][1]["name"]	"Bill"

# For more control, an asterisk can stand in for any part of the keypath.
$ echo $json | jason 'users[*][*]'
this["users"][0]["name"]	"Amy"
this["users"][0]["age"]	12
this["users"][1]["name"]	"Bill"
this["users"][1]["age"]	42

# The root element is always referred to as 'this', so you always have the tools
# you need to effectively process (and reprocess) JSON.
$ echo $json | jason this.users | cut -f 2 | jason this:age | cut -f 2
12
42
```

### Why not?

* It can be very slow on moderately large JSON structures.
* Search keypaths are bound to be a little fragile, and are unlikely to handle
  keys with escapes well.
* It may parse invalid JSON erroneously.
* Debugging can be a pain.
