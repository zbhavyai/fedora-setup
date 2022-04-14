# Settings for Eclipse IDE

### Indentation using spaces

1.  Open Window -> Preferences -> General -> Text Editors
2.  Select `Insert spaces for tabs`

### LF line endings

1.  Open Window -> Preferences -> General -> Workspace
2.  Select `Other: Unix` under "New text file line delimiter"

### Autoformat code on save

1.  Open Window -> Preferences -> Java -> Editor -> Save Actions
2.  Select `Perform the selected actions on save`
3.  Select `Format source code` and `Format all lines`
4.  Select `Additional actions` and configure...
5.  Make sure below is displayed

    ```
    Remove 'this' qualifier for non static field accesses
    Remove 'this' qualifier for non static method accesses
    Convert control statement bodies to block
    Add missing '@Override' annotations
    Add missing '@Override' annotations to implementations of interface methods
    Add missing '@Deprecated' annotations
    Remove unnecessary casts
    Remove trailing white spaces on all lines
    Correct indentation
    ```
