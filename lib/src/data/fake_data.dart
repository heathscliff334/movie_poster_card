List<Map<String, dynamic>> sampleMovies = [
  {
    "id": 0,
    "colorHighlight": "#037ffc",
    "title": "Guardian of The Galaxy Vol. 1",
    "synopsis":
        "Peter escapes from the planet Morag with a valuable orb that Ronan the Accuser wants. He eventually forms a group with unwilling heroes to stop Ronan.",
    "image": "image1.jpg",
    "genres": ["Action", "Adventure", "Comedy"],
    "rating": 8.0,
  },
  {
    "id": 1,
    "colorHighlight": "#eaf51d",
    "title": "Top Gun: Maverick",
    "synopsis":
        "After thirty years, Maverick is still pushing the envelope as a top naval aviator, but must confront ghosts of his past when he leads TOP GUN's elite graduates on a mission that demands the ultimate sacrifice from those chosen to fly it.",
    "image": "image2.jpg",
    "genres": ["Action", "Drama"],
    "rating": 8.3,
  },
  {
    "id": 2,
    "colorHighlight": "#a113e8",
    "title": "John Wick: Chapter 3 - Parabellum",
    "synopsis":
        "John Wick is on the run after killing a member of the international assassins guild, and with a 14 million dollars price tag on his head, he is the target of hit men and women everywhere.",
    "image": "image3.jpeg",
    "genres": ["Action", "Crime", "Thriller"],
    "rating": 7.4,
  },
];

Map<String, dynamic> fakeApiResponse = {
  "isSuccess": true,
  "data": sampleMovies,
  "errors": "exception",
};
