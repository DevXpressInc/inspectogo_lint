# TODO

## Lints to implement

- Line length
- Newline between class members
- Newline after variable declaration block
- No multiple empty lines
- Document all class fields
- Document all public classes
- Trailing spaces not allowed
- No side effects (instanciation of class without assignation)
- Class members follow the right order (Hard)
  1. Constructors, with the default constructor first.
  2. Constants of the same type as the class.
  3. Static methods that return the same type as the class.
  4. Final fields that are set from the constructor.
  5. Other static methods.
  6. Static properties and constants.
  7. Members for mutable properties, without new lines separating the members of a property, each property in the order:
      - getter
      - private field
      - setter
  8. Read-only properties (other than hashCode).
  9. Operators (other than ==).
  10. Overridden methods (except for dispose).
  11. The build method, for Widget and State classes.
  12. dispose (if it is a StatefulWidget)
  13. Private methods.
  14. operator ==, hashCode, toString, and diagnostics-related methods, in that order.
