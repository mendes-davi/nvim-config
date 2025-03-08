;; extends
;;
;; inherits: vhdl

(entity_declaration
  entity: (identifier) @name
  (#set! "kind" "Class")) @symbol

(entity_declaration
  (entity_head
    (
     (generic_clause (#set! "kind" "Interface")) @symbol) @name
    (#set! @name "text" "generic")
    )
  )

(entity_declaration
  (entity_head
    (generic_clause
      (interface_list
        (interface_declaration
          (identifier_list
            generic: (identifier) @name
            )
          (#set! "kind" "Field")
          ) @symbol
        )
      )
    )
  )

(entity_declaration
  (entity_head
    (
     (port_clause (#set! "kind" "Interface")) @symbol) @name
    (#set! @name "text" "port")
    )
  )

(entity_declaration
  (entity_head
    (port_clause
      (interface_list
        (interface_declaration
          (identifier_list
            (identifier) @name
            )
          (#set! "kind" "Field")
          ) @symbol
        )
      )
    )
  )

(architecture_definition
  architecture: (identifier) @name
  (#set! "kind" "Module")
  ) @symbol


(architecture_definition
  (
   (architecture_head) @symbol) @name
  (#set! @name "text" "declaration")
  (#set! "kind" "Constructor")
  )

(architecture_definition
  (
   (concurrent_block) @symbol) @name
  (#set! @name "text" "body")
  (#set! "kind" "Constructor")
  )

(architecture_definition
  (architecture_head
    (constant_declaration
      (identifier_list
        constant: (identifier) @name
        )
      (#set! "kind" "Constant")
      ) @symbol
    )
  )

(architecture_definition
  (architecture_head
    (signal_declaration
      (identifier_list
        (identifier) @name
        )
      (#set! "kind" "Variable")
      ) @symbol
    )
  )

(architecture_definition
  (concurrent_block
    (component_instantiation_statement
      (label_declaration (label) @name)
      (#set! "kind" "Struct")
      ) @symbol
    )
  )

(architecture_definition
  (concurrent_block
    (component_instantiation_statement
      (
       (generic_map_aspect) @name
       (#set! @name "text" "generic map")
       (#set! "kind" "Interface")
       ) @symbol
      )
    )
  )

(architecture_definition
  (concurrent_block
    (component_instantiation_statement
      (
       (port_map_aspect) @name
       (#set! @name "text" "port map")
       (#set! "kind" "Interface")
       ) @symbol
      )
    )
  )

(architecture_definition
  (concurrent_block
    (component_instantiation_statement
      (generic_map_aspect
        (association_list
          ((association_element) @name) @symbol
          (#set! "kind" "EnumMember")
          (#gsub! @name "[ ]+" " ")
          (#gsub! @name "[	]+" " ")
          )
        )
      )
    )
  )

(architecture_definition
  (concurrent_block
    (component_instantiation_statement
      (port_map_aspect
        (association_list
          ((association_element) @name) @symbol
          (#set! "kind" "EnumMember")
          (#gsub! @name "[ ]+" " ")
          (#gsub! @name "[	]+" " ")
          )
        )
      )
    )
  )

(architecture_definition
  (concurrent_block
    (process_statement
      (label_declaration (label) @name)?
      (sequential_block) @selection
      (#set! "kind" "File")
      ) @symbol
    )
  )

