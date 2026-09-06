---
title: "Tool calling"
linkTitle: "Tool calling"
type: "docs"
weight: 50
description: >
  Let a model call your Go functions.
---

A model cannot do arithmetic well and it cannot read the clock. Tool calling solves this. You tell the model which functions it has, the model asks for one, and your Go code runs it.

## Before you start

Use a model that supports tool calling:

```shell
yzma model get -u https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-fp16.gguf
```

## Run the example

```shell
$ go run ./examples/tooluse/ -model ~/models/qwen2.5-0.5b-instruct-fp16.gguf
=== Tool Calling Example ===

User: What is 15 + 27?

Assistant: 15 + 27 = 42

The result of adding 15 and 27 is 42.
```

Ask your own question:

```shell
$ go run ./examples/tooluse/ -model ~/models/qwen2.5-0.5b-instruct-fp16.gguf -question="what is 9 times 9?"
```

[See the code](https://github.com/hybridgroup/yzma/blob/main/examples/tooluse/main.go).

## Describe your tools

A tool definition gives the name of the function, what it does, and the parameters that it takes.

```go
tools := []message.ToolDefinition{
	{
		Type: "function",
		Function: message.ToolFunctionDefinition{
			Name:        "add",
			Description: "Add two numbers together",
			Parameters: map[string]interface{}{
				"type": "object",
				"properties": map[string]interface{}{
					"a": map[string]interface{}{
						"type":        "number",
						"description": "The first number",
					},
					"b": map[string]interface{}{
						"type":        "number",
						"description": "The second number",
					},
				},
				"required": []string{"a", "b"},
			},
		},
	},
}
```

The description matters. The model reads it to decide when to use the tool. Write a clear description.

## Send the tools to the model

Put the tool definitions in the system prompt as JSON, then build the messages:

```go
messages := []message.Message{
	message.Chat{Role: "system", Content: systemPrompt},
	message.Chat{Role: "user", Content: question},
}
```

## Read the answer

The model writes the tool calls in its answer. `ParseToolCalls` reads them:

```go
toolCalls := message.ParseToolCalls(response)
```

`StripMarkup` removes the tool call markers, so you can print the text that the model said:

```go
fmt.Printf("Assistant: %s\n", message.StripMarkup(response))
```

## Run the tool and send the result back

```go
for _, call := range toolCalls {
	result, err := executeToolCall(call)
	if err != nil {
		continue
	}

	messages = append(messages, message.Tool{
		Role:      "assistant",
		ToolCalls: []message.ToolCall{call},
	})
	messages = append(messages, message.ToolResponse{
		Role:    "tool",
		Content: result,
	})
}
```

Then run the model again. It now has the result and it can answer the question.

## More than one step

The `multitool` example repeats this loop until the model asks for no more tools. This lets the model solve a problem in steps.

```shell
go run ./examples/multitool -model ~/models/Qwen3-VL-2B-Instruct-Q8_0.gguf -question "Tell me what is (15 + 27) * 3"
```

[See the code](https://github.com/hybridgroup/yzma/blob/main/examples/multitool/main.go).

## Each model family is different

Each model family writes a tool call in its own way. `pkg/message` reads all of them.

| Format | What it looks like |
| --- | --- |
| `FormatStandard` | Bare JSON in `<tool_call>` tags |
| `FormatQwen` | `<function=name>` with `<parameter=key>` tags |
| `FormatGLM` | `<arg_key>` and `<arg_value>` tags |
| `FormatMistral` | `[TOOL_CALLS]name[ARGS]{...}` |
| `FormatGemma3` | Turn markers, with the system text in the first user turn |
| `FormatGemma` | `call:name{key:value}` |
| `FormatGPT` | `.name <\|message\|>{...}` |
| `FormatPhi` | Standard JSON, with its own turn markers |

`ParseToolCalls` finds the format without help. `DetectFormat` reads the format from the answer, and `DetectFormatFromPath` reads it from the name of the model file.

## Stop markers

A model must stop when it finishes a turn. Each format has its own end of turn markers. `StopMarkers` gives them:

```go
markers := message.StopMarkers(vocab, format)
```

Stop the generation loop when the text ends with one of these markers.

## Next steps

Go to [Browser](/docs/tutorials/browser/).
