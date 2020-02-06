//
//  LinkTag.swift
//  App
//
//  Created by Paul Hudson on 30/12/2017.
//

import Async
import Foundation
import Leaf

public final class LinkTag: TagRenderer {
    public func render(tag parsed: TagContext) throws -> Future<TemplateData> {
        // make sure we have precisely one parameter
        try parsed.requireParameterCount(1)

        // prepare to send back some data
        return Future.map(on: parsed.container) {
            // check we were given a dictionary containing an ID and slug
            if let dict = parsed.parameters[0].dictionary, let id = dict["id"]?.string, let slug = dict["slug"]?.string {
                // send it back as a path
                return .string("/read/\(id)/\(slug)")
            } else {
                // missing data – send back null
                return .null
            }
        }
    }
}
