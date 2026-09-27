import 'package:flutter/material.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF263238),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Ratings & Reviews',
          style: TextStyle(
            color: Color(0xFF172B24),
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            14,
            10,
            14,
            25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // OVERALL RATING CARD
              // ==================================================

              _overallRating(),

              const SizedBox(height: 14),

              // ==================================================
              // RATING BREAKDOWN
              // ==================================================

              _ratingBreakdown(),

              const SizedBox(height: 18),

              // ==================================================
              // SECTION TITLE
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Buyer Reviews',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF172B24),
                    ),
                  ),

                  Text(
                    '120+ reviews',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ==================================================
              // REVIEWS
              // ==================================================

              _reviewCard(
                name: 'Suresh Kumar',
                location: 'Saharanpur, Uttar Pradesh',
                rating: 5,
                date: 'Today',
                review:
                    'Very fresh vegetables and excellent quality. Packaging was also very good.',
                initials: 'SK',
              ),

              _reviewCard(
                name: 'FreshMart Agra',
                location: 'Agra, Uttar Pradesh',
                rating: 5,
                date: 'Yesterday',
                review:
                    'The potatoes were fresh and delivered exactly as ordered. Good quality produce.',
                initials: 'FA',
              ),

              _reviewCard(
                name: 'Organic Hub Delhi',
                location: 'New Delhi, Delhi',
                rating: 4,
                date: '23 Sep 2026',
                review:
                    'Good quality tomatoes. Delivery was smooth and the produce was properly packed.',
                initials: 'OH',
              ),

              _reviewCard(
                name: 'Rahul Sharma',
                location: 'Dehradun, Uttarakhand',
                rating: 5,
                date: '21 Sep 2026',
                review:
                    'Great farmer. Products were fresh and exactly matched the description.',
                initials: 'RS',
              ),

              _reviewCard(
                name: 'Green Basket',
                location: 'Haridwar, Uttarakhand',
                rating: 4,
                date: '19 Sep 2026',
                review:
                    'Overall good experience. Fresh produce and responsive communication.',
                initials: 'GB',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OVERALL RATING
  // ============================================================

  Widget _overallRating() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE9F9F0),
            Color(0xFFF8FFFA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD7EDE1),
        ),
      ),
      child: Row(
        children: [

          // --------------------------------------------------
          // RATING NUMBER
          // --------------------------------------------------

          Expanded(
            flex: 4,
            child: Column(
              children: [

                const Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF087C59),
                  ),
                ),

                _stars(
                  rating: 4.8,
                  size: 20,
                ),

                const SizedBox(height: 5),

                Text(
                  'Overall Rating',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  '120+ buyers',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF087C59),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          Container(
            width: 1,
            height: 105,
            color: const Color(0xFFDCEBE2),
          ),

          const SizedBox(width: 15),

          // --------------------------------------------------
          // RIGHT SIDE
          // --------------------------------------------------

          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Text(
                  'Customer satisfaction',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Most buyers rated your products highly.',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_alt_rounded,
                      size: 16,
                      color: Color(0xFF087C59),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '96%',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Color(0xFF087C59),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'positive ratings',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: .96,
                    minHeight: 7,
                    backgroundColor:
                        const Color(0xFFDCEFE4),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(0xFF087C59),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RATING BREAKDOWN
  // ============================================================

  Widget _ratingBreakdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5EAE7),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            'Rating Breakdown',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172B24),
            ),
          ),

          const SizedBox(height: 13),

          _ratingBar(
            stars: 5,
            percentage: .82,
            count: 98,
          ),

          _ratingBar(
            stars: 4,
            percentage: .12,
            count: 14,
          ),

          _ratingBar(
            stars: 3,
            percentage: .04,
            count: 5,
          ),

          _ratingBar(
            stars: 2,
            percentage: .02,
            count: 2,
          ),

          _ratingBar(
            stars: 1,
            percentage: .01,
            count: 1,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RATING BAR
  // ============================================================

  Widget _ratingBar({
    required int stars,
    required double percentage,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [

          SizedBox(
            width: 35,
            child: Row(
              children: [
                Text(
                  '$stars',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.star_rounded,
                  size: 13,
                  color: Color(0xFFFFB300),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 7,
                backgroundColor:
                    const Color(0xFFEAEFED),
                valueColor:
                    const AlwaysStoppedAnimation(
                  Color(0xFFFFB300),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 25,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REVIEW CARD
  // ============================================================

  Widget _reviewCard({
    required String name,
    required String location,
    required int rating,
    required String date,
    required String review,
    required String initials,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5EAE7),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          // --------------------------------------------------
          // BUYER INFO
          // --------------------------------------------------

          Row(
            children: [

              Container(
                width: 39,
                height: 39,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F5E9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF087C59),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  Color(0xFF172B24),
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: Color(0xFF087C59),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [

                        Icon(
                          Icons.location_on_outlined,
                          size: 11,
                          color: Colors.grey.shade500,
                        ),

                        const SizedBox(width: 2),

                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9.5,
                              color:
                                  Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Text(
                date,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // --------------------------------------------------
          // STARS
          // --------------------------------------------------

          _stars(
            rating: rating.toDouble(),
            size: 15,
          ),

          const SizedBox(height: 7),

          // --------------------------------------------------
          // REVIEW
          // --------------------------------------------------

          Text(
            review,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: Color(0xFF4E5B61),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STARS
  // ============================================================

  Widget _stars({
    required double rating,
    double size = 18,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          final difference =
              rating - index;

          if (difference >= 1) {
            return Icon(
              Icons.star_rounded,
              size: size,
              color: const Color(0xFFFFB300),
            );
          }

          if (difference >= .5) {
            return Icon(
              Icons.star_half_rounded,
              size: size,
              color: const Color(0xFFFFB300),
            );
          }

          return Icon(
            Icons.star_outline_rounded,
            size: size,
            color: const Color(0xFFFFB300),
          );
        },
      ),
    );
  }
}