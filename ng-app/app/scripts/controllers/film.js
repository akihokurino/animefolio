'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:FilmCtrl
 * @description
 * # FilmCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("FilmCtrl", function ($scope, $location, http) {
	$scope.api = {
		film: null,
	};

 	$scope.initialize = function () {
 		var film_id = $location.path().split("/").pop();
 		http.getFilm($scope.api, film_id);
 	}

 	$scope.strimWidth = function (str, max) {
 		if(str && str.length > parseInt(max)){
			str = str.slice(0, parseInt(max));
			str += "...";
			return str;
		}
		return str;
 	}
});

