import Foundation
import Leaf
import Routing
import SwiftGD
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("home", context)
    }

    router.get("fetch") { req -> Future<String> in
        let imageString = try image(from: req).map(to: String.self) { img in
            guard let img = img else { return "" }

            let asciiBlocks = ["@", "#", "*", "+", ";", ":", ",", ".", "`", " "]
            let imageSize = img.size
            let blockSize = 2

            var rows = [[String]]()
            rows.reserveCapacity(imageSize.height)

            // loop over the height of the image
            for y in stride(from: 0, to: imageSize.height, by: blockSize) {
                // create a new row and reserve enough capacity for all our pixels
                var row = [String]()
                row.reserveCapacity(imageSize.width)

                // loop over the width of the image
                for x in stride(from: 0, to: imageSize.width, by: blockSize) {
                    // get the pixel at the current location
                    let color = img.get(pixel: Point(x: x, y: y))

                    // figure out its brightness
                    let brightness = color.redComponent + color.greenComponent + color.blueComponent

                    // multiply by three then round to an integer
                    let sum = Int(round(brightness * 3))

                    // map that brightness to an ASCII character
                    row.append(asciiBlocks[sum])
                }

                // append this to our result
                rows.append(row)
            }

            let output = rows.reduce("") {
                $0 + $1.joined(separator: " ") + "\n"
            }

            return output
        }

        return imageString
    }
}

func image(from request: Request) throws -> Future<Image?> {
    guard let uri: String = request.query["url"] else {
        return Future.map(on: request) { return nil }
    }

    let imageResponse = try request.client().get(uri)

    return imageResponse.flatMap(to: Image?.self) { imageResponse in
        let temporaryName = NSTemporaryDirectory().appending("input.png")
        let temporaryURL = URL(fileURLWithPath: temporaryName)

        return imageResponse.http.body.consumeData(max: 16000000, on: request).map(to: Image?.self) { data in
            try data.write(to: temporaryURL)

            if let image = Image(url: temporaryURL) {
                return image
            } else {
                return nil
            }
        }
    }
}

