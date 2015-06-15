## Paragraphs

Paragraphs are separated by empty newlines.

    This is a paragraph
    This line is part of the same paragraph

    This is a new paragraph

## Manual Line Breaks

End a line with two or more spaces:

    Roses are red,
    Violets are blue.

## Headers

Add a number of hash signs `#` equal to the header level

    # Header Level 1
    ## Header Level 2
    ## Header Level 3

## Lists

Ordered list use numbers:

    1. Foo
    2. Bar

Unordered lists use dashes or stars:

    - A list item.
    - A list item.
    - A list item.

    * Foo
    * Bar

You can nest them:

    - First
        - Second
    - Bastard
        1. Brownian motion
        2. bupkis
            - BELITTLER
        3. burper
    - Cunning

## Blockquotes

    > Email-style angle brackets
    > are used for blockquotes.

## Phrase Emphasis

    *italic*   **bold**
    _italic_   __bold__

## Links

Inline links:

    An [example](http://example.com/)

Reference-style links:

    An [example][id]. Then, anywhere
    else in the doc, define the link:

    [id]: http://example.com/

Email Links: Email addresses are automatically parsed by Markdown, but if you want to add an email subject or other parameters to the link, you would do it like this:

    [email@example.org](mailto:email@example.org?subject=Insert%20Subject)

## Inline Images

Simple inline images (not recommended) can be inserted with:

    ![alt text](/path/img.jpg)

## Code Spans

Inline code is delimited with backticks

    `code` spans are delimited
    by backticks.

For full pre-formatted code blocks, indent every line of a code block by at least 4 spaces.

        This is a pre-formatted
        code block.
