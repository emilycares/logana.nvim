describe("file", function()
  local content =
    "/home/michael/Documents/rust/logana/src/main.rs:16:5|type annotations needed\nC:\\home\\michael\\Documents\\rust\\logana\\src\\main.rs:16:5|type annotations needed"

  it("should parse messages correctly", function()
    local out = require("lua.logana.file").parse(content)

    assert.equals(out[1].filename, "/home/michael/Documents/rust/logana/src/main.rs")
    assert.equals(out[1].lnum .. "", 16 .. "")
    assert.equals(out[1].col .. "", 5 .. "")
    assert.equals(out[1].text, "type annotations needed")

    assert.equals(out[2].filename, "C:\\home\\michael\\Documents\\rust\\logana\\src\\main.rs")
    assert.equals(out[2].lnum .. "", 16 .. "")
    assert.equals(out[2].col .. "", 5 .. "")
    assert.equals(out[2].text, "type annotations needed")
  end)
end)
