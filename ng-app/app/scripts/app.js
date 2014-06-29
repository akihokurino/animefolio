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
		templateUrl: 'views/main.html',
		controller: 'MainCtrl'
	})
	.otherwise({
		redirectTo: '/'
	});
});
