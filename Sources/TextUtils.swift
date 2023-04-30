//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    extension NSLayoutManager {
        func enclosingRects(in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> [CGRect] {
            var lineRects = [CGRect]()
            enumerateLineFragments(
                forGlyphRange: glyphRange)
            { _, usedRect, _, _, _ in
                lineRects.append(usedRect)
            }

            var enclosingRects = [CGRect]()
            enumerateEnclosingRects(
                forGlyphRange: glyphRange,
                withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                in: textContainer
            ) { rect, _ in
                enclosingRects.append(rect)
            }
            
            var result = [CGRect]()
            for enclosingRect in enclosingRects {
                var r = enclosingRect
                for lineRect in lineRects {
                    if abs(enclosingRect.origin.y - lineRect.origin.y) < 0.0001 {
                        r = lineRect
                    }
                }
                result.append(enclosingRect.intersection(r))
            }
            return result
        }
    }

#endif
