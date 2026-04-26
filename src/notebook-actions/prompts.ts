/*
 * Copyright (c) Jupyter Development Team.
 * Distributed under the terms of the Modified BSD License.
 */

/**
 * Prompt templates for notebook cell AI actions.
 *
 * Inspired by https://github.com/TiesdeKok/chat-gpt-jupyter-extension
 */

/**
 * Wrap code in a fenced code block that is safe even if the code contains
 * triple backticks. Uses the shortest fence longer than any backtick run
 * already present in the code (CommonMark §4.5 rule).
 */
function safeFence(code: string): string {
  const match = code.match(/`+/g);
  const maxLen = match ? Math.max(...match.map(m => m.length)) : 0;
  const fence = '`'.repeat(Math.max(3, maxLen + 1));
  return `${fence}\n${code}\n${fence}`;
}

/**
 * Build the "Format" prompt.
 *
 * The AI should improve formatting, add comments, docstrings, and type hints
 * without altering the logic.  The response MUST contain a single fenced code
 * block with the formatted code so it can be extracted and applied back to the
 * cell.
 */
export function formatPrompt(focalCode: string): string {
  return `You are a coding assistant helping the user improve the formatting of their code.

## Rules
- Do NOT alter the logic or behaviour of the code.
- Improve spacing and indentation.
- Add concise inline comments where helpful.
- Add or improve docstrings.
- Add type hints where appropriate.
- Only wrap the code in a function if the original code was already in a function.
- Respond with the formatted code inside a single fenced code block.
- After the code block, briefly list the improvements you made.

## Code
${safeFence(focalCode)}

Provide the formatted code now.`;
}

/**
 * Build the "Explain" prompt.
 *
 * The AI should explain the code in a clear, ELI5 style.
 */
export function explainPrompt(
  focalCode: string,
  previousCode: string,
  stdout: string,
  errorOutput: string
): string {
  let prompt = `You are a coding assistant. Explain the following code as clearly as possible (ELI5 style).

## Rules
- Provide a concise high-level summary first.
- Then give a line-by-line explanation where reasonable, using inline comments in a code block.
- Use markdown formatting.
`;

  if (previousCode) {
    prompt += `
## Context from previous cells
${safeFence(previousCode)}
`;
  }

  prompt += `
## Code to explain
${safeFence(focalCode)}
`;

  if (stdout) {
    prompt += `
## Standard output
${safeFence(stdout)}
`;
  }

  if (errorOutput) {
    prompt += `
## Error output
${safeFence(errorOutput)}
`;
  }

  prompt += '\nExplain the code now.';
  return prompt;
}

/**
 * Build the "Debug" prompt.
 *
 * The AI should diagnose the error and suggest a fix.
 */
export function debugPrompt(
  focalCode: string,
  previousCode: string,
  errorOutput: string
): string {
  let prompt = `You are a coding assistant helping the user debug a code issue.

## Rules
- Clearly describe the problem.
- Explain why the code is failing or throwing an error.
- Provide a corrected version of the code inside a single fenced code block.
- After the code block, briefly explain the fix.
`;

  if (previousCode) {
    prompt += `
## Context from previous cells
${safeFence(previousCode)}
`;
  }

  prompt += `
## Code with the issue
${safeFence(focalCode)}
`;

  if (errorOutput) {
    prompt += `
## Error message
${safeFence(errorOutput)}
`;
  } else {
    prompt += `
(No error output captured — the user believes there is a bug.)
`;
  }

  prompt += '\nDiagnose and fix the code now.';
  return prompt;
}

/**
 * Build the "Complete" prompt.
 *
 * The AI should complete a partial code snippet.
 */
export function completePrompt(
  focalCode: string,
  previousCode: string
): string {
  let prompt = `You are a coding assistant helping the user complete the code they are writing.

## Rules
- Only complete the code in the focal cell; do NOT repeat context from previous cells.
- Do not wrap the code in a function unless the user started one.
- Respond with the completed code inside a single fenced code block.
- After the code block, briefly summarise what was added.
`;

  if (previousCode) {
    prompt += `
## Context from previous cells
${safeFence(previousCode)}
`;
  }

  prompt += `
## Code to complete
${safeFence(focalCode)}

Complete the code now.`;
  return prompt;
}

/**
 * Build the "Review" prompt.
 *
 * The AI should provide a constructive code review.
 */
export function reviewPrompt(focalCode: string, previousCode: string): string {
  let prompt = `You are a code reviewer reviewing the following code.

## Rules
- Be constructive and suggest concrete improvements.
- Do NOT give generic compliments or a summary — get straight to the points.
- Do NOT comment on code outside the focal cell.
- Do NOT recommend about unused variables (you have no knowledge of subsequent cells).
- Ignore import-related suggestions.
- Reference the relevant line(s) of code in a markdown code block under each comment.
- Do NOT end with the full updated code.
`;

  if (previousCode) {
    prompt += `
## Context from previous cells
${safeFence(previousCode)}
`;
  }

  prompt += `
## Code to review
${safeFence(focalCode)}

Provide the code review now.`;
  return prompt;
}
