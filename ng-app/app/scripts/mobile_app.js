'use strict';

/**
* @ngdoc overview
* @name ngAppApp
* @description
* # ngAppApp
*
* Main module of the application.
*/

angular.module('animefolio', [
	'ngAnimate',
	'ngCookies',
	'ngResource',
	'ngRoute',
	'ngSanitize',
	'ngTouch'
])
.config(function ($routeProvider) {
	$routeProvider
	.when('/', {
		templateUrl: 'views/mobile/films.html',
		controller: 'FilmsCtrl'
	})
	.when('/contents/:film_id', {
		templateUrl: 'views/mobile/film.html',
		controller: 'FilmCtrl'
	})
	.when('/content/:film_id/:content_id', {
		templateUrl: 'views/mobile/content.html',
		controller: 'ContentCtrl'
	})
	.otherwise({
		redirectTo: '/'
	});
});
