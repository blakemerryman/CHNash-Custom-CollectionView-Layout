import UIKit
import PlaygroundSupport

/*:
 Helper function to present the view controller as a live view in the Assistant Editor window.
 Specials thanks to @samcorder (Twitter) for this great helper function!
 */
public func presentViewController(controller: UIViewController) {
  let navController = UINavigationController(rootViewController: controller)
  PlaygroundPage.current.needsIndefiniteExecution = true
  PlaygroundPage.current.liveView = navController
}
