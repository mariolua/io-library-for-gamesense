# Lua IO Library Re-creation for Gamesense

This Lua script is a re-creation of the IO library specifically designed for Gamesense. This re-creation does not include all the functions of the original IO library, but it provides the core functionality for file and console IO. This library is useful when the standard IO library is not available or doesn't suit your specific needs.

## Features
This library features several functions that replicate some functionality from the original Lua IO library. These functions include:
* `io.open`: opens a file in the specified mode.
* `io.lines`: iterates over the lines in a file.
* `io.write`: writes to the output.
* `io.read`: reads from the input.
* `io.close`: closes the output.

In addition to these, a file object returned by `io.open` has the following methods:
* `file:read`: reads from the file.
* `file:lines`: iterates over the lines in the file.
* `file:write`: writes to the file.
* `file:flush`: flushes the file content to disk.
* `file:seek`: seeks to a position in the file.
* `file:close`: closes the file.

## Usage

```lua
-- Import the module
local io = require "io"

-- Open a file in read mode
local file = io.open("test.txt", "r")

-- Read the entire file
local content = file:read("*a")
print(content)

-- Close the file
file:close()
```

## Note
Remember to replace "io" with the actual path to this IO library script when using require. Also, note that this script assumes the existence of readfile and writefile functions. Please make sure they are available in your runtime environment or replace them with appropriate functions.

## License
This script is released under the MIT License.

## Contribution
Feel free to contribute to this project by opening issues or submitting pull requests. All contributions are welcome!

## Disclaimer
This script was created as an alternative to Lua's IO library and is not an official re-creation. The developers of this script are not responsible for any issues that might occur during its use.
