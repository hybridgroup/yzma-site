---
title: "Tool calling"
linkTitle: "Tool calling"
type: "docs"
weight: 50
description: >
  How a model calls your Go functions.
---

Tool calling lets a model ask your program to run a function. The model writes a request, your code runs the function, and you send the result back.

See [the tutorial](/docs/tutorials/tool-calling/) for a complete program. This page holds the details.

## The parts

`pkg/message` holds these types.

| Type | What it is |
| --- | --- |
| `ToolDefinition` | The description of a tool that you give the model. |
| `ToolFunctionDefinition` | The name, the description, and the parameters of a function. |
| `ToolCall` | A request from the model to run one function. |
| `ToolFunction` | The name and the arguments of that request. |
| `Tool` | A message that holds tool calls, and the text that came with them. |
| `ToolResponse` | The result that you send back to the model. |
| `Chat` | A normal message with a role and content. |

## Read the tool calls

```go
toolCalls := message.ParseToolCalls(response)
```

`ParseToolCalls` finds the format without help. It reads every format that the table below lists.

`StripMarkup` removes the tool call markers from the text:

```go
fmt.Println(message.StripMarkup(response))
```

`TextAfterToolCalls` gives the text that comes after the last tool call.

## Each model family writes a tool call in its own way

| Format | What it looks like |
| --- | --- |
| `FormatStandard` | Bare JSON, such as `{"name":"...","arguments":{...}}` |
| `FormatQwen` | `<function=name>` with `<parameter=key>` tags |
| `FormatGLM` | `funcname<arg_key>key</arg_key><arg_value>value</arg_value>` |
| `FormatMistral` | `[TOOL_CALLS]funcname[ARGS]{...}` |
| `FormatGemma3` | Turn markers. There is no system role, so the system text goes in the first user turn. |
| `FormatGemma` | `call:funcname{key:value}` |
| `FormatGPT` | `.FUNC_NAME <\|message\|>JSON_ARGS` |
| `FormatPhi` | Standard JSON with its own turn markers |
| `FormatAuto` | No known format was found. |

## Find the format

`DetectFormat` reads the format from the answer. It looks at the markers in the text only. It does not look at the name of the model.

```go
format := message.DetectFormat(response)
```

`DetectFormatFromPath` reads the format from the name of the model file:

```go
format := message.DetectFormatFromPath("~/models/Qwen3-4B-Q4_K_M.gguf")
```

Use `DetectFormatFromPath` before the first answer, when you have no text yet.

## Stop markers

A model must stop at the end of its turn. Each format has its own markers.

```go
markers := message.StopMarkers(vocab, format)
```

`StopMarkersFor` takes the end of turn strings directly:

```go
markers := message.StopMarkersFor(eot, format)
```

Stop the generation loop when the text ends with one of these markers.

## Write a good tool description

The model reads the description to decide when to use the tool. A poor description gives a poor result.

- Say what the function does, not how it works.
- Name each parameter and say what it holds.
- Put every parameter that the function needs in the `required` list.
- Keep the name short and clear.

```go
message.ToolFunctionDefinition{
	Name:        "get_weather",
	Description: "Get the current weather for a city",
	Parameters: map[string]interface{}{
		"type": "object",
		"properties": map[string]interface{}{
			"city": map[string]interface{}{
				"type":        "string",
				"description": "The name of the city",
			},
		},
		"required": []string{"city"},
	},
}
```

## Arguments come back as strings

`ToolFunction.Arguments` is a `map[string]string`. Convert each value to the type that your function needs, and check the result.

```go
a, err := strconv.ParseFloat(call.Function.Arguments["a"], 64)
if err != nil {
	// The model gave a value that is not a number.
}
```

A small model makes mistakes. Always check the arguments before you use them.

## Put the tools in the template

`template.ApplyWithTools` puts the tool definitions in the prompt with the template of the model:

```go
prompt, err := template.ApplyWithTools(tmpl, messages, tools, true)
```

See [Chat templates](/docs/guides/chat-templates/).

## In a browser

Tool calling works in a browser. `pkg/message` has a version of `StopMarkers` for WebAssembly. See the `tools.html` page in the `wasm` directory of the repository.
