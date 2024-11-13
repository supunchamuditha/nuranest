import 'package:flutter/material.dart';

class PsychologistArticleView extends StatelessWidget {
  const PsychologistArticleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Articals",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const HomeScreenContent(), // Display the content
    );
  }
}

// Separate widget for HomeScreen content (previously in your HomeScreen)
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReadArticleCard(context),
        ],
      ),
    );
  }

  Widget _buildReadArticleCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: const Color(0xFFF5EDD3), // Light beige color
      child: Padding(
        padding: const EdgeInsets.all(20), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Effects of Sleep Deprivation",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Image.asset(
                  'lib/assets/images/18.png', // Replace with your image path
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Sleep deprivation has a profound and far-reaching impact on cognitive function, emotional stability, \n "
              "and physical health. Lack of adequate sleep impairs memory, concentration, and decision-making skills,\n"
              " making it difficult to retain information, focus on tasks, and make sound judgments. This cognitive impairment \n"
              "is especially concerning for individuals who need to make critical decisions or who engage in tasks requiring sustained\n"
              " mental effort. Additionally, sleep deprivation increases irritability, stress levels, and emotional sensitivity, often leading\n"
              " to mood swings, decreased patience, and reduced tolerance for stress.In the long term, prolonged sleep deprivation can have severe \n"
              "consequences for mental health, including increased risks of anxiety disorders, depression, and other mood-related conditions. Chronic sleep loss disrupts the balance of neurotransmitters in the brain,\n"
              " affecting emotional regulation and making individuals more prone to feelings of sadness, hopelessness, and despair. Physically, sleep deprivation weakens the immune system, leaving the body more susceptible to infections and illnesses. \n"
              "Over time, inadequate sleep has been linked to a higher risk of chronic health conditions, including obesity, high blood pressure, cardiovascular disease, and even certain forms of cancer.Quality sleep is essential for maintaining metabolic health, as it regulates hormones involved in appetite, energy storage, and glucose metabolism. People who consistently sleep less than the recommended hours are more likely to experience issues with weight management, insulin resistance, and increased appetite, especially for high-calorie, sugary foods.Furthermore, prioritizing sleep is crucial not just for physical health but also for maintaining optimal mental performance, \n"
              "emotional resilience, and overall well-being. A consistent, restful sleep pattern allows the brain to consolidate memories, process emotions, and rejuvenate, leading to improved focus, better learning outcomes, and a more positive outlook on life. Embracing good sleep hygiene—such as sticking to a regular sleep schedule, creating a relaxing bedtime routine, and limiting exposure to screens before bedcan help individuals enjoy the full benefits of restorative sleep, ultimately contributing to a happier, healthier, and more productive life." ,     
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9DD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ACSC SampleName\n2014/01/01",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
