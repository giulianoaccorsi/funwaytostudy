//
//  MarkdownTag.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Async
import Foundation
import Leaf
import Markdown

public final class MarkdownTag: TagRenderer {
    public func render(tag parsed: TagContext) throws -> Future<TemplateData> {
        try parsed.requireParameterCount(1)

        return Future.map(on: parsed.container) {
            // this time we expect to be given a single string
            if let str = parsed.parameters[0].string {
                // fix the line breaks
                let trimmed = str.replacingOccurrences(of: "\r\n", with: "\n")

                // parse the Markdown string
                if let md = Markdown(string: trimmed) {
                    // send it back
                    return .string(md.html)
                } else {
                    // something went wrong – send back null
                    return .null
                }
            } else {
                return .null
            }
        }
    }
}
