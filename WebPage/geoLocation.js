document.addEventListener('DOMContentLoaded', () => {
    const storedLatitude = localStorage.getItem('latitude');
    const storedLongitude = localStorage.getItem('longitude');

    if (storedLatitude && storedLongitude) {
        fetchWeatherData(storedLatitude, storedLongitude).then(async data => {
            currentWeather = data.current;
            dailyWeather = data.daily.slice(0, 7);
            hourlyWeather = data.hourly.slice(0, 24);
            cityName = await fetchCityName(storedLatitude, storedLongitude);
            displayCurrentWeather(cityName);
            createDailyWeatherChart(dailyWeather);
            createHourlyWeatherChart(hourlyWeather);
        }).catch(error => {
            document.getElementById('location').innerHTML = 'Error fetching weather data.';
            console.error('Error fetching weather data:', error);
        });
    } else {
        getLocation();
    }
});

let isCelsius = true;
let dailyWeather = [];
let hourlyWeather = [];
let currentWeather = {};
let dailyWeatherChart;
let hourlyWeatherChart;
let cityName = '';

document.getElementById('searchCityButton').addEventListener('click', () => {
    const cityNameInput = document.getElementById('cityInput').value;
    if (cityNameInput) {
        fetchCityCoordinates(cityNameInput).then(async ({ latitude, longitude }) => {
            fetchWeatherData(latitude, longitude).then(async data => {
                currentWeather = data.current;
                dailyWeather = data.daily.slice(0, 7);
                hourlyWeather = data.hourly.slice(0, 24);
                cityName = await fetchCityName(latitude, longitude);
                displayCurrentWeather(cityName);
                createDailyWeatherChart(dailyWeather);
                createHourlyWeatherChart(hourlyWeather);
            }).catch(error => {
                document.getElementById('location').innerHTML = 'Error fetching weather data.';
                console.error('Error fetching weather data:', error);
            });
        }).catch(error => {
            document.getElementById('location').innerHTML = 'Error fetching city coordinates.';
            console.error('Error fetching city coordinates:', error);
        });
    }
});

document.getElementById('toggleTemp').addEventListener('click', () => {
    isCelsius = !isCelsius;
    const toggleButton = document.getElementById('toggleTemp');
    toggleButton.innerHTML = isCelsius ? '°F' : '°C';

    dailyWeather = dailyWeather.map(entry => ({
        ...entry,
        temperature: isCelsius ? (entry.temperature - 32) * (5 / 9) : (entry.temperature * 9 / 5) + 32
    }));

    hourlyWeather = hourlyWeather.map(entry => ({
        ...entry,
        temperature: isCelsius ? (entry.temperature - 32) * (5 / 9) : (entry.temperature * 9 / 5) + 32
    }));

    currentWeather.temperature = isCelsius ? (currentWeather.temperature - 32) * (5 / 9) : (currentWeather.temperature * 9 / 5) + 32;
    displayCurrentWeather(cityName); 
    createDailyWeatherChart(dailyWeather);
    createHourlyWeatherChart(hourlyWeather);
});

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
        document.getElementById('location').innerHTML = 'Geolocation is not supported by this browser.';
    }
}

async function showPosition(position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;

    localStorage.setItem('latitude', latitude);
    localStorage.setItem('longitude', longitude);

    try {
        const weatherData = await fetchWeatherData(latitude, longitude);
        currentWeather = weatherData.current;
        dailyWeather = weatherData.daily.slice(0, 7);
        hourlyWeather = weatherData.hourly.slice(0, 24);
        cityName = await fetchCityName(latitude, longitude);
        displayCurrentWeather(cityName);
        createDailyWeatherChart(dailyWeather);
        createHourlyWeatherChart(hourlyWeather);
    } catch (error) {
        document.getElementById('location').innerText = 'Error fetching weather data.';
        console.error('Error fetching weather data:', error);
    }
}

function showError(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            document.getElementById('location').innerHTML = 'User denied the request for Geolocation.';
            break;
        case error.POSITION_UNAVAILABLE:
            document.getElementById('location').innerHTML = 'Location information is unavailable.';
            break;
        case error.TIMEOUT:
            document.getElementById('location').innerHTML = 'The request to get user location timed out.';
            break;
        case error.UNKNOWN_ERROR:
            document.getElementById('location').innerHTML = 'An unknown error occurred.';
            break;
    }
}

async function fetchCityCoordinates(cityNameInput) {
    const apiKey = '41c12a26a8674b34ac7e7ab583cd2ffc'; 
    const apiUrl = `https://api.opencagedata.com/geocode/v1/json?q=${cityNameInput}&key=${apiKey}`;

    try {
        const response = await fetch(apiUrl);
        const data = await response.json();

        if (!data.results || data.results.length === 0) {
            throw new Error('No results found for the specified city');
        }

        const { lat, lng } = data.results[0].geometry;
        return { latitude: lat, longitude: lng };
    } catch (error) {
        console.error('Error fetching city coordinates:', error);
        throw error;
    }
}

async function fetchWeatherData(latitude, longitude) {
    const apiKey = 'ce2b68fa32184aa1253a0cea0375de96'; 
    const apiUrl = `https://api.openweathermap.org/data/3.0/onecall?lat=${latitude}&lon=${longitude}&exclude=minutely&appid=${apiKey}`;

    console.log('Fetching weather data for:', latitude, longitude);

    try {
        const response = await fetch(apiUrl);
        const data = await response.json();

        console.log('API Response:', data);

        if (!data.current || !data.daily || !data.hourly) {
            throw new Error('Invalid API response structure');
        }

        return {
            current: {
                temperature: data.current.temp - 273.15,
                weather: data.current.weather[0].main,
                description: data.current.weather[0].description,
                sunrise: data.current.sunrise,
                sunset: data.current.sunset
            },
            daily: data.daily.map(day => ({
                temperature: day.temp.day - 273.15,
                date: new Date(day.dt * 1000).toLocaleDateString(),
                dayOfWeek: new Date(day.dt * 1000).toLocaleString('en-US', { weekday: 'short' }),
                weather: day.weather[0].main
            })),
            hourly: data.hourly.map(hour => ({
                temperature: hour.temp - 273.15,
                time: new Date(hour.dt * 1000).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
                weather: hour.weather[0].main
            }))
        };
    } catch (error) {
        console.error('Error fetching weather data:', error);
        throw error;
    }
}

async function fetchCityName(latitude, longitude) {
    const apiKey = 'API KEY GOES HERE'; 
    const apiUrl = `url`;

    try {
        const response = await fetch(apiUrl);
        const data = await response.json();

        if (!data.results || data.results.length === 0) {
            throw new Error('No results found for the specified coordinates');
        }

        const cityName = data.results[0].components.city || data.results[0].components.town || data.results[0].components.village;
        return cityName;
    } catch (error) {
        console.error('Error fetching city name:', error);
        throw error;
    }
}

function displayCurrentWeather(cityName) {
    const currentWeatherElement = document.getElementById('currentWeather');
    const temperature = isCelsius ? currentWeather.temperature : (currentWeather.temperature * 9 / 5) + 32;
    const unit = isCelsius ? '°C' : '°F';

    const sunrise = new Date(currentWeather.sunrise * 1000).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    const sunset = new Date(currentWeather.sunset * 1000).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    currentWeatherElement.innerHTML = `
        <h3 class="weather-location">${cityName}</h3>
        <p class="weather-condition">${currentWeather.description}</p>
        <div class="weather-footer">
            <div class="weather-footer-sun">
                <p>Sunrise: ${sunrise}</p>
                <p>Sunset: ${sunset}</p>
            </div>    
            <div class="weather-footer-temp">${temperature.toFixed(2)}${unit}</div>
        </div>
    `;

    let backgroundImage = '';

    switch (currentWeather.weather.toLowerCase()) {
        case 'clear':
            backgroundImage = 'url(images/sun.gif)';
            break;
        case 'clouds':
            backgroundImage = 'url(images/clouds.gif)';
            break;
        case 'rain':
            backgroundImage = 'url(images/rain.gif)';
            break;
        case 'snow':
            backgroundImage = 'url(images/snow.gif)';
            break;
        case 'thunderstorm':
            backgroundImage = 'url(images/thunderstorm.gif)';
            break;
        default:
            backgroundImage = 'url(images/default.jpg)';
            break;
    }

    currentWeatherElement.style.position = 'relative';
    currentWeatherElement.style.overflow = 'hidden';

    const backgroundElement = document.createElement('div');
    backgroundElement.style.position = 'absolute';
    backgroundElement.style.top = 0;
    backgroundElement.style.left = 0;
    backgroundElement.style.width = '100%';
    backgroundElement.style.height = '100%';
    backgroundElement.style.backgroundImage = backgroundImage;
    backgroundElement.style.backgroundSize = 'cover';
    backgroundElement.style.backgroundPosition = 'center';
    backgroundElement.style.opacity = '0.5'; 
    backgroundElement.style.zIndex = '-1';

    currentWeatherElement.appendChild(backgroundElement);
}

function createDailyWeatherChart(dailyWeather) {
    const ctx = document.getElementById('dailyWeatherChart').getContext('2d');

    if (dailyWeatherChart) {
        dailyWeatherChart.destroy();
    }

    const temperatures = dailyWeather.map(entry => isCelsius ? entry.temperature : (entry.temperature * 9 / 5) + 32);
    const labels = dailyWeather.map(entry => entry.dayOfWeek);

    const weatherIcons = dailyWeather.map(entry => {
        switch (entry.weather.toLowerCase()) {
            case 'clear':
                return '☀️';
            case 'clouds':
                return '☁️';
            case 'rain':
                return '🌧️';
            case 'snow':
                return '❄️';
            case 'thunderstorm':
                return '⛈️';
            default:
                return '❓';
        }
    });

    dailyWeatherChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: `Weekly Forecast (${isCelsius ? '°C' : '°F'})`,
                data: temperatures,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return `${context.dataset.label}: ${context.raw.toFixed(2)}${isCelsius ? '°C' : '°F'}`;
                        }
                    }
                },
                legend: {
                    display: true, 
                    labels: {
                        boxWidth: 20,
                        padding: 15
                    }
                }
            },
            scales: {
                y: {
                    display: true,
                    beginAtZero: true
                },
                x: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value, index) {
                            const icon = weatherIcons[index];
                            return icon + ' ' + labels[index];
                        }
                    }
                }
            },
            responsive: true,
            maintainAspectRatio: false
        },
        plugins: [{
            id: 'customPlugin',
            afterDatasetsDraw: (chart) => {
                const ctx = chart.ctx;
                const chartArea = chart.chartArea;
                const barMeta = chart.getDatasetMeta(0).data;

                chart.data.labels.forEach((label, index) => {
                    const bar = barMeta[index];
                    const barCenterX = bar.x;
                    const temperature = temperatures[index].toFixed(1) + (isCelsius ? '°C' : '°F');

                    ctx.save();
                    ctx.textAlign = 'center';
                    ctx.font = '12px Arial';
                    ctx.fillStyle = '#f7f1e3'; 
                    ctx.fillText(temperature, barCenterX, chartArea.bottom - 8);
                    ctx.restore();
                });
            }
        }]
    });
}

function createHourlyWeatherChart(hourlyWeather) {
    const ctx = document.getElementById('hourlyWeatherChart').getContext('2d');

    if (hourlyWeatherChart) {
        hourlyWeatherChart.destroy();
    }

    const temperatures = hourlyWeather.map(entry => isCelsius ? entry.temperature : (entry.temperature * 9 / 5) + 32);
    const labels = hourlyWeather.map(entry => entry.time);

    hourlyWeatherChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: `Hourly Temperature (${isCelsius ? '°C' : '°F'})`,
                data: temperatures,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}
