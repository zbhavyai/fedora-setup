# Settings for Eclipse IDE

### Indentation using spaces

1.  Open Window -> Preferences -> General -> Text Editors
2.  Select `Insert spaces for tabs`

### LF line endings

1.  Open Window -> Preferences -> General -> Workspace
2.  Select `Other: Unix` under "New text file line delimiter"

### Tab switching

1. Open Window -> Preferences -> General -> Keys
2. Filter for "tab"
3. Use `Copy command` to copy the commands `Next Tab` and `Previous Tab`
4. Add `Ctrl+Tab` binding for `Next Tab`
5. Add `Ctrl+Shift+Tab` binding for `Previous Tab`

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

### Some useful eclipse shortcuts

| Key combo          | Function                                             |
| ------------------ | ---------------------------------------------------- |
| `F3`               | Jump to the implementation of the method             |
| `Ctrl + Alt + H`   | View call hierarchy of the method                    |
| `F4`               | View class hierarchy of the highlighted class        |
| `Ctrl + O`         | Class outline to navigate between methods and fields |
| `Ctrl + Shift + R` | Find and open any file in the workspace by name      |
| `Ctrl + Alt + Z`   | Surrond code with try-catch, or loops                |
| `Ctrl + Shift + O` | Add missing imports, organize existing imports       |
| `Alt + Shift + R`  | Refactor variable                                    |
| `Ctrl + Shift + F` | Auto format file or highlighted code                 |
| `Ctrl + F11`       | Run the program                                      |
| `Ctrl + Shift + L` | List all shortcuts                                   |
