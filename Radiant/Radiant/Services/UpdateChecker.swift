import AppKit

class UpdateChecker {
    private let repoOwner = "Evandabest"
    private let repoName = "Radiant"
    private let checkInterval: TimeInterval = 86400 // 24 hours
    private let lastCheckKey = "lastUpdateCheck"

    var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    func checkForUpdates(force: Bool = false) {
        if !force {
            let lastCheck = UserDefaults.standard.double(forKey: lastCheckKey)
            if Date().timeIntervalSince1970 - lastCheck < checkInterval { return }
        }

        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastCheckKey)

        let urlString = "https://api.github.com/repos/\(repoOwner)/\(repoName)/releases/latest"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self, let data, error == nil else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let tagName = json["tag_name"] as? String,
                  let htmlURL = json["html_url"] as? String else { return }

            let latestVersion = tagName.trimmingCharacters(in: CharacterSet.letters.union(.punctuationCharacters))

            if self.isNewer(latestVersion, than: self.currentVersion) {
                DispatchQueue.main.async {
                    self.showUpdateAlert(version: tagName, url: htmlURL)
                }
            }
        }.resume()
    }

    private func isNewer(_ remote: String, than local: String) -> Bool {
        let remoteParts = remote.split(separator: ".").compactMap { Int($0) }
        let localParts = local.split(separator: ".").compactMap { Int($0) }

        for i in 0..<max(remoteParts.count, localParts.count) {
            let r = i < remoteParts.count ? remoteParts[i] : 0
            let l = i < localParts.count ? localParts[i] : 0
            if r > l { return true }
            if r < l { return false }
        }
        return false
    }

    private func showUpdateAlert(version: String, url: String) {
        let alert = NSAlert()
        alert.messageText = "Update Available"
        alert.informativeText = "Radiant \(version) is available. You are currently on v\(currentVersion)."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Download")
        alert.addButton(withTitle: "Later")

        if alert.runModal() == .alertFirstButtonReturn {
            if let downloadURL = URL(string: url) {
                NSWorkspace.shared.open(downloadURL)
            }
        }
    }
}
