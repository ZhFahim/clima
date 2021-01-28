import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen(this.locationWeather);
  final locationWeather;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherModel weather = WeatherModel();

  int temperature;
  String weatherIcon;
  String weatherMessage;
  String cityName;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData != null) {
        var temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        weatherIcon = weather.getWeatherIcon(weatherData['weather'][0]['id']);
        weatherMessage =
            weather.getMessage(temperature) + ' in ' + weatherData['name'];
      } else {
        temperature = null;
        weatherIcon = '';
        weatherMessage = 'Something went wrong';
        cityName = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    minWidth: 0,
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 40.0,
                    ),
                  ),
                  FlatButton(
                    minWidth: 0,
                    onPressed: () async {
                      String cityName = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityScreen()),
                      );
                      if (cityName != null && cityName.trim().isNotEmpty) {
                        var weatherData =
                            await weather.getCityWeather(cityName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.search,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temperature != null ? '$temperature°' : 'Oops!',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "$weatherMessage!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
