import 'package:flutter/material.dart';
import 'package:lawod/model/weather_model.dart';
import 'package:lawod/service/weather_services.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('ae5edc955b107c3f9023be6b48361ed9');
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thundercloud.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json'; // Provide a default value for unknown conditions
    }
  }

  String getFishingCondition(String? mainCondition) {
    if (mainCondition == null) return "Fish with caution";

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'Fishing with caution!';
      case 'thunderstorm':
        return 'Not safe for fishing!';
      case 'clear':
        return 'Good for fishing!';
      default:
        return 'Fish with caution!'; // Provide a default value for unknown conditions
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'ProximaNova',
        // Add other theme configurations...
      ),
      home: Scaffold(
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First Container
                      Container(
                        width: 342,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF196DFF), Color(0xFF362A84)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              // Temperature and Location
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_weather?.temperature.round() ?? ""}°',
                                      style: TextStyle(
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      getFishingCondition(_weather?.mainCondition),
                                      style: TextStyle(fontSize: 13, color: Colors.white),
                                    ),
                                    Text(
                                      _weather?.cityName ?? "loading city...",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10), // Added spacing
                              // Animation and Condition
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Lottie.asset(
                                  getWeatherAnimation(_weather?.mainCondition),
                                  width: 160,
                                  height: 160,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 36), // Distance between containers

                      // Second Container with "Fish Finder" text and "Explore" button
                      Stack(
                        children: [
                          Container(
                            width: 340,
                            height: 519,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/fishfinder.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Positioned(
                            top: 377,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                'Fish Finder',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 434,
                            left: 25,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your Explore button functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFFAB19),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                fixedSize: Size(289, 55),
                              ),
                              child: Text(
                                'Explore',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
