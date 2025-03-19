import 'package:flutter/material.dart';

class CustomerSupportScreen extends StatefulWidget {
  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  String? selectedService;
  List<String> questions = [];
  List<String> flightFAQs = [];
  List<String> hotelFAQs = [];
  List<String> trainFAQs = [];
  List<String> carRentalFAQs = [];
  List<String> attractionsFAQs = [];
  List<String> airportTransfersFAQs = [];

  final Map<String, List<String>> serviceQuestions = {
    'Flights': [
      'Are there any flight ticket promotions going on?',
      'How do I change my ticket?',
      'How can I cancel my flight ticket?',
    ],
    'Hotels & Homes': [
      'Where can I find booking information?',
      'Do the guest names on the booking have to be the same as the names of the guests checking in?',
      'How do I see what amenities are provided in a room?',
    ],
    'Trains': [
      'How can I change my train tickets?',
      'How do I purchase Railcards on Trip.com?',
      'Where can I find the Railcards I\'ve already purchased?',
    ],
    'Car Rentals': [
      'How do I confirm my rental vehicle information?',
      'Are there any license/ID/age requirements?',
      'How can I cancel the booking?',
    ],
    'Airport Transfers': [
      'How do I change the pick-up time of my booking?',
      'How long will the driver wait for free?',
      'How many pieces of baggage will fit in the car?',
    ],
    'Attractions & Tours': [
      'How do I book a tour or ticket?',
      'How do I use the item I booked?',
      'What will I receive after successfully booking a tour or ticket?',
    ],
  };

  final Map<String, List<String>> flightFAQTopics = {
    'Hot Topics': [
      'How do I change my ticket?',
      'How can I cancel my flight ticket?',
      'What should I do if my flight schedule changed or my flight was canceled?',
    ],
    'Booking & Price': [
      'How do I book a flight?',
      'How to book student tickets?',
      'What is the price breakdown for flight tickets?',
    ],
    'Ticketing & Payment': [
      'How do I book child or infant tickets online?',
      'Why do ticket prices fluctuate?',
      'Why can’t I make my booking?',
    ],
    'Booking Query': [
      'What is Flexibooking?',
      'Can I book special assistance for my flight?',
      'What is a “code-sharing flight”?',
    ],
    'Passenger Information-related': [
      'How should I enter my passenger information?',
      'Can I book a flight without an ID?',
      'How do I change the name on my booking?',
    ],
    'Cancel Tickets': [
      'What is the cancellation policy for my flight?',
      'May I know the refund method?',
      'What is an airline voucher, and how do I use it?',
    ],
  };

  final Map<String, List<String>> hotelFAQTopics = {
    'Hot Topics': [
      'How can I cancel my booking?',
      'How can I modify my booking?',
      'When will I receive my refund?',
    ],
    'Booking Query': [
      'How do I book hotels on Trip.com?',
      'How do I check a hotel\'s star rating?',
      'How do I use promo codes?',
    ],
    'Cancellation and Modification': [
      'Why was my booking canceled?',
      'What is the deadline for canceling or changing my hotel reservation?',
      'Can the cancellation be restored?',
    ],
    'Booking Information': [
      'What is my confirmation number?',
      'How do I get another confirmation email?',
      'When will my booking be confirmed?',
    ],
    'Payments and Refunds': [
      'Will my refund be issued to my original account of payment?',
      'Payment failed for my booking, what should I do?',
      'How do I pay for a booking?',
    ],
    'Special Requests': [
      'How can I add special requests?',
      'How can I request an e-receipt/invoice?',
      'How do I contact the hotel?',
    ],
  };

  final Map<String, List<String>> trainFAQTopics = {
    'Booking': [
      'How do I book train tickets?',
      'What kinds of seats can be booked?',
      'Can I book by phone?',
      'How can I pick up tickets?',
      'What payment methods can I use?',
    ],
    'Taking the Train': [
      'What to know when entering the station and boarding the train?',
      'Can I take the train if I lost my ID?',
      'Can I board the train at a different station?',
      'How do I make a transfer?',
      'Are there baggage restrictions?',
    ],
    'Changes & Refunds': [
      'How can I refund tickets online?',
      'How much are ticket refund handling fees?',
      'How can I change tickets or my arrival station online?',
      'How much are ticket change handling fees?',
      'Changes and Refunds Within the Railway Station',
    ],
    'Refunds': [
      'How will I be refunded for price differences?',
      'When will I get a refund after cancelling my booking?',
      'When will I get a refund if ticket purchase has failed?',
      'When will I receive a refund for ticket changes/cancellations?',
      'How can I receive a refund for the cancellation/change an e-ticket?',
    ],
    'Cross Boundary Train Policies': [
      'What are tickets with a transfer/round-trip tickets?',
      'What are the policies for cross-boundary trains?',
      'Can I book cross-boundary train tickets online?',
      'What are the restrictions for cross-boundary trains?',
      'How do I get a refund for cross-boundary train tickets?',
    ],
  };

  final Map<String, List<String>> carRentalFAQTopics = {
    'Bookings': [
      'How do I book a car?',
      'Can I specify the brand and car model I want?',
      'What should I do if I need to cross a border into another country/region?',
      'How is the rental period calculated?',
      'I’ve paid but haven’t received a confirmation email or pick-up voucher, what should I do?',
    ],
    'Driver and License Requirements': [
      'Are there any license requirements?',
      'Do car rental companies have any restrictions about license expiry dates?',
      'What kind of driving license do I need?',
      'What is an additional driver?',
      'Are there any requirements for additional drivers?',
    ],
    'Pick-up & Drop-off': [
      'What documents do I need to bring when I pick up the car?',
      'When picking the car up at the branch, is there anything I need to pay attention to?',
      'Are there any checks I need to do when I pick up the car?',
      'What should I do if the branch gives me a poor quality car?',
      'What happens if the car is damaged?',
    ],
    'Prices and Payments': [
      'How do I avoid paying additional fees when I drop off the car?',
      'Can I drop the car off later than I originally planned?',
      'How do I get the proof for reimbursement?',
      'Does the rental supplier offer additional insurance and other add-ons?',
      'How do I purchase additional insurance and add-ons?',
    ],
  };

  final Map<String, List<String>> attractionsFAQTopics = {
    'Booking': [
      'How do I book a tour or ticket?',
      'How do I know if my booking has been confirmed?',
      'What will I receive after successfully booking a tour or ticket?',
      'What should I do if I don\'t receive my e-ticket or voucher?',
      'Can I change my booking information after the booking has been confirmed?',
    ],
    'Change & Cancel': [
      'Can I apply for a refund?',
      'How do I apply for a refund?',
      'Can I change the date of use after the booking has been confirmed?',
      'What should I do if I need to cancel my booking?',
      'What is the cancellation policy for tours and tickets?',
    ],
    'Price & Payment': [
      'What is included in the price of the tour or ticket?',
      'Are there any additional fees?',
      'What payment methods are accepted?',
      'Can I get a discount for group bookings?',
      'How do I use promo codes for tours and tickets?',
    ],
  };

  final Map<String, List<String>> airportTransfersFAQTopics = {
    'Booking': [
      'How do I book an airport transfer?',
      'How far in advance should I book?',
      'Can I choose a specific car make or model?',
      'How do I select an airport drop-off time?',
      'What pick-up time should I select?',
    ],
    'Pricing and Payment': [
      'How do I pay?',
      'What’s included in the total cost of the booking?',
      'Are prices calculated based on the car or the number of passengers?',
      'Is there a fee if I exceed the waiting time?',
      'How to get an e-receipt?',
    ],
    'Changes and Cancellations': [
      'How do I change the pick-up time of my booking?',
      'How to cancel the booking? Will there be a fee?',
      'My flight has been delayed/canceled, how do I cancel my booking?',
      'Why was my booking canceled?',
      'Can I restore a canceled booking?',
    ],
    'Taking the Car': [
      'How many items of baggage will fit in the car?',
      'Can I bring baggage with me during my airport transfer?',
      'How do I choose a car?',
      'What should I do if the car is late?',
      'What happens if the driver doesn’t show up?',
    ],
  };

  void _onServiceSelected(String service) {
    setState(() {
      selectedService = service;
      questions = serviceQuestions[service] ?? [];
    });
  }

  void _onQuestionClicked(String question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatBoxScreen(question: question),
      ),
    );
  }

  void _onFlightFAQTopicClicked(String topic) {
    setState(() {
      flightFAQs = flightFAQTopics[topic] ?? [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQScreen(faqs: flightFAQs, topic: topic),
      ),
    );
  }

  void _onHotelFAQTopicClicked(String topic) {
    setState(() {
      hotelFAQs = hotelFAQTopics[topic] ?? [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQScreen(faqs: hotelFAQs, topic: topic),
      ),
    );
  }

  void _onTrainFAQTopicClicked(String topic) {
    setState(() {
      trainFAQs = trainFAQTopics[topic] ?? [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQScreen(faqs: trainFAQs, topic: topic),
      ),
    );
  }

  void _onCarRentalFAQTopicClicked(String topic) {
    setState(() {
      carRentalFAQs = carRentalFAQTopics[topic] ?? [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQScreen(faqs: carRentalFAQs, topic: topic),
      ),
    );
  }

  void _onAttractionsFAQTopicClicked(String topic) {
    setState(() {
      attractionsFAQs = attractionsFAQTopics[topic] ?? [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQScreen(faqs: attractionsFAQs, topic: topic),
      ),
    );
  }

  void _onAirportTransfersFAQTopicClicked(String topic) {
    setState(() {
      airportTransfersFAQs = airportTransfersFAQTopics[topic] ?? [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQScreen(faqs: airportTransfersFAQs, topic: topic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2D4A53),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.laptop, size: 30, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A636A),
              Color(0xFFAFB3B7),
              Color(0xFF69818D),
              Color(0xFF2D4A53),
              Color(0xFF132E35),
              Color(0xFF0D1F23),
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tourify',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Customer Support.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, size: 20, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Customer Support in Seconds',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Horizontally scrollable service options
            Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildServiceOption(Icons.flight, "Flights"),
                  buildServiceOption(Icons.hotel, "Hotels & Homes"),
                  buildServiceOption(Icons.train, "Trains"),
                  buildServiceOption(Icons.directions_car, "Car Rentals"),
                  buildServiceOption(Icons.airport_shuttle, "Airport Transfers"),
                  buildServiceOption(Icons.attractions, "Attractions & Tours"),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Display questions based on selected service
            if (selectedService != null) ...[
              Text(
                'Questions for $selectedService',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return MouseRegion(
                      onEnter: (_) => setState(() {}),
                      onExit: (_) => setState(() {}),
                      child: GestureDetector(
                        onTap: () => _onQuestionClicked(questions[index]),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  questions[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 24),

            // Additional features from the screenshot
            if (selectedService == 'Flights') ...[
              Text(
                'More Flights FAQ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildFlightFAQButton('Hot Topics'),
                  _buildFlightFAQButton('Booking & Price'),
                  _buildFlightFAQButton('Ticketing & Payment'),
                  _buildFlightFAQButton('Booking Query'),
                  _buildFlightFAQButton('Passenger Information-related'),
                  _buildFlightFAQButton('Cancel Tickets'),
                ],
              ),
            ],
            if (selectedService == 'Hotels & Homes') ...[
              Text(
                'More Hotels & Homes FAQ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildHotelFAQButton('Hot Topics'),
                  _buildHotelFAQButton('Booking Query'),
                  _buildHotelFAQButton('Cancellation and Modification'),
                  _buildHotelFAQButton('Booking Information'),
                  _buildHotelFAQButton('Payments and Refunds'),
                  _buildHotelFAQButton('Special Requests'),
                ],
              ),
            ],
            if (selectedService == 'Trains') ...[
              Text(
                'More Trains FAQ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildTrainFAQButton('Booking'),
                  _buildTrainFAQButton('Taking the Train'),
                  _buildTrainFAQButton('Changes & Refunds'),
                  _buildTrainFAQButton('Refunds'),
                  _buildTrainFAQButton('Cross Boundary Train Policies'),
                ],
              ),
            ],
            if (selectedService == 'Car Rentals') ...[
              Text(
                'More Car Rentals FAQ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildCarRentalFAQButton('Bookings'),
                  _buildCarRentalFAQButton('Driver and License Requirements'),
                  _buildCarRentalFAQButton('Pick-up & Drop-off'),
                  _buildCarRentalFAQButton('Prices and Payments'),
                ],
              ),
            ],
            if (selectedService == 'Attractions & Tours') ...[
              Text(
                'More Attractions & Tours FAQ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildAttractionsFAQButton('Booking'),
                  _buildAttractionsFAQButton('Change & Cancel'),
                  _buildAttractionsFAQButton('Price & Payment'),
                ],
              ),
            ],
            if (selectedService == 'Airport Transfers') ...[
              Text(
                'More Airport Transfers FAQ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildAirportTransfersFAQButton('Booking'),
                  _buildAirportTransfersFAQButton('Pricing and Payment'),
                  _buildAirportTransfersFAQButton('Changes and Cancellations'),
                  _buildAirportTransfersFAQButton('Taking the Car'),
                ],
              ),
            ],
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Chat', Icons.chat),
                _buildActionButton('Call Us', Icons.call),
                _buildActionButton('FAQ', Icons.help),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceOption(IconData icon, String title) {
    return GestureDetector(
      onTap: () => _onServiceSelected(title),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8),
        color: Color(0xFF2D4A53),
        child: Container(
          width: 100,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightFAQButton(String text) {
    return ElevatedButton(
      onPressed: () => _onFlightFAQTopicClicked(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildHotelFAQButton(String text) {
    return ElevatedButton(
      onPressed: () => _onHotelFAQTopicClicked(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildCarRentalFAQButton(String text) {
    return ElevatedButton(
      onPressed: () => _onCarRentalFAQTopicClicked(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildAttractionsFAQButton(String text) {
    return ElevatedButton(
      onPressed: () => _onAttractionsFAQTopicClicked(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildTrainFAQButton(String text) {
    return ElevatedButton(
      onPressed: () => _onTrainFAQTopicClicked(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildAirportTransfersFAQButton(String text) {
    return ElevatedButton(
      onPressed: () => _onAirportTransfersFAQTopicClicked(text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        if (text == 'Chat') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          );
        } else if (text == 'Call Us') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallUsScreen(),
            ),
          );
        } else if (text == 'FAQ') {
          // Handle FAQ button logic
        }
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class ChatBoxScreen extends StatelessWidget {
  final String question;

  ChatBoxScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Customer Support'),
        backgroundColor: Color(0xFF2D4A53),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'Question: $question',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Placeholder for chat messages
                Text('Customer Service: How can I assist you with "$question"?'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Send message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  final List<String> faqs;
  final String topic;

  FAQScreen({required this.faqs, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
        backgroundColor: Color(0xFF2D4A53),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faqs[index],
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels Service Chat'),
        backgroundColor: Color(0xFF2D4A53),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'Trip.com Chatbot',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hi, Tourify Member. We\'re glad to be able to help you out.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'You might want to ask:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _buildChatOption('How do I contact the hotel?'),
                _buildChatOption('How can I modify my booking?'),
                _buildChatOption('How can I cancel my booking?'),
                _buildChatOption('How can I request an e-receipt/invoice?'),
                SizedBox(height: 16),
                Text(
                  'Payment failed for my booking, what should I do?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Please describe your problem in one sentence',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Send message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatOption(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class CallUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Us'),
        backgroundColor: Color(0xFF2D4A53),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHotline('United States', '+1-800-123-4567'),
          _buildHotline('United Kingdom', '+44-20-7946-0958'),
          _buildHotline('Australia', '+61-2-8015-6789'),
          _buildHotline('India', '+91-80-1234-5678'),
          _buildHotline('Singapore', '+65-6789-1234'),
          _buildHotline('China', '+86-10-1234-5678'),
        ],
      ),
    );
  }

  Widget _buildHotline(String country, String number) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          country,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          number,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: Icon(Icons.phone, color: Colors.blue),
        onTap: () {
          // Handle call logic
        },
      ),
    );
  }
}