;; extends
;;
;; inherits: ruby

(call
  method: (constant) @method @name
  arguments: (argument_list
    [
      (string
        (string_content) @name)
      (simple_symbol) @name
      (pair
        key: [
          (string
            (string_content) @name)
          (hash_key_symbol) @name
        ])
      (call) @name
    ])?
  (#set! "kind" "Method")) @symbol @selection
