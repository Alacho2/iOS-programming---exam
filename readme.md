## PG5600 exam - iOS Programming
Candidate number: 5038

Xcode version: 11.2.1

iOS simulator version: 13.2.2

This is my exam in iOS Programming at Kristiania University College (Høyskolen Kristiania Oslo).
The task was to create a simple app to keep track of a users favorite tracks, list albums, search
through music based on a public API, show a Top 50 list of albums from the same API, give a detailed
view of the albums music, allow the user to rearrange the tracks in the underlying database, and 
provide recommended artists based on the users favorite music.

### Highlights of the exam include
* A network call to fetch data, based on generics that is usable in any situation, whatever data
the response might contain. (Write once, run anywhere).
* A tableview sorting the underlying tracks in Core Data, allowing the user to make a top list
of their tracks.
* Image caching with the help of the library Kingfisher, because Apple doesn't provide a good
API for caching image.
* A simple persistence handler to avoid having to find the AppDelegate for each time we're
accessing the database.

### Pods used
In order to make the exam as good as possible, I needed to include two libraries in use.

##### Kingfisher
Kingfisher is a handler library for downloading and caching images. In this case it's used
because Apple doesn't provide an API for caching images. In the Favorite controller, we need
to process 50 high res images to make the list. 

There were two problems when doing this manually:
* Whenever the images of the FavoriteController was downloaded, it could take up to 12 seconds
before the app began showing content.
* Whenever this was done on the fly, the UI was lagging out and we sometimes ended up with
covers placed on the wrong album.

The pro of this is that we get a smooth transition for images, at the same time that we
get a simple placeholder for images not existing. 

This con of Kingfisher is that it writes the high res image to the disk (and to memory),
and in some cases this might end up consuming unnecessary amounts of storage.
Though it is highly worth it to get a smooth UI/UX in our case.

#### Alamofire
Networks requests are important. They are high targets of attacks and vulnerable to hackers 
and malicious people. That's why I decided to use Alamofire for handling networks requests.
By using a sophisticated open source library, we're getting a higher chance of removing
potential security holes and unknown traps, especially for us as students. 

Alamofire also makes the handling of response, error and status code a lot simpler than
using the standard URLSession-API Apple provides. The disadvantage, however, is that we
give away a lot of control to writing network requests and we're including a library 
for very little code. Even though we can write extensions to further increase our own
control over the code running, we can't guarantee it fully. In my opinion, the code also
becomes more readable, understandable and maintainable. More elegant, as their slogan is.

For further reading, I'd like to point to this article:
https://www.avanderlee.com/swift/alamofire-vs-urlsession/

### Notable mentions
I think it's good that we can agree on one thing. NSFetchedResultsControllerDelegate is
not working as it should in iOS 13. Once we've established that, you'll see the beauty in
my way of updating the sortId for core data. 

Firstly, when we attempt to use .move and .update, they won't be triggered until you've called
the sortId when moving. Meaning that the delegate becomes useless, as you manually need to trigger it.

Secondly, since the NSFetchedResultsControllerDelegate is not working, we need to manually set 
the order in the database, this might trigger discrepancy. Nevertheless, I have, to
the best of my ability, worked around these discrepancies and had to implement the delegate
from scratch.

So dear examiner, I hope you can see the beauty in what I created, even though the code is...
very childish.

### The grade
It's rare that I ever try to grade myself, but I feel, given the circumstances, that I could
give it a try. Given everything I've implemented, and how I have implemented it, and solved
all the tasks for the exam, I'd grade myself with an A.
