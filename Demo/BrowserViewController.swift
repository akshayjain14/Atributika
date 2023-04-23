//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import UIKit

class BrowserViewController: UIViewController {
    private let attributedTextView = AttributedTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browser"
        view.backgroundColor = .white
        view.addSubview(attributedTextView)

        attributedTextView.isScrollEnabled = true
        attributedTextView.isSelectable = true
        attributedTextView.alwaysBounceVertical = true
        attributedTextView.numberOfLines = 0
        attributedTextView.linkHighlightViewFactory = RoundedRectLinkHighlightViewFactory()
        attributedTextView.disabledLinkAttributes = Attrs().foregroundColor(.lightGray).attributes
        attributedTextView.onLinkTouchUpInside = { [weak self] _, val in
            if let linkStr = val as? String {
                self?.loadUrl(linkStr)
            }
        }

        attributedTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            attributedTextView.topAnchor.constraint(equalTo: view.topAnchor),
            attributedTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            attributedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            attributedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        loadUrl("https://example.com")
    }

    private func loadUrl(_ urlString: String) {
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                return
            }
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                return
            }

            self.updateWithHTML(text)
        }

        task.resume()
    }

    private func updateWithHTML(_ htmlString: String) {
        let a = TagTuner {
            Attrs().akaLink($0.tag.attributes["href"] ?? "").foregroundColor(.blue)
        }

        let attributedText = htmlString
            .style(tags: ["a": a])
            .attributedString

        DispatchQueue.main.async {
            self.attributedTextView.attributedText = attributedText
        }
    }
}
