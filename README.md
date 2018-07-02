# GitTest
Sample application that fetches most recent repos from GitHub

# Architecture
The app is built in a MVP aproach and as such folows its guidlines. Each screen is separated into its view its model and a presenter thats facilitates the comunication between the two as well as handling all the business logic.

The provider handles fetching data from the api or local storage (more specifically CoreData) using services created for these functions.

There are no third party frameworks added to the project so all the networking calls are done through basic requests and images are cached in the Apple provided NSCache.

# Future improvements

The main future improvement to be added is a cached page of the latest repositories to be displayed on the repositories screen in case there is no internet connection. Progress indicators should also be added.
