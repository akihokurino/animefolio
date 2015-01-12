'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:HeaderCtrl
 * @description
 * # HeaderCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("HeaderCtrl", function ($scope) {
	$scope.search = function (keyword) {
		var tmp_keyword = keyword;
		keyword         = null;
		$(".keyword").val("");
		location.href   = "#/?keyword=" + tmp_keyword;
	}

	$scope.enter = function (keyword) {
		if (event.keyCode === 13 && keyword) {
	    var tmp_keyword = keyword;
			keyword         = null;
			$(".keyword").val("");
			location.href   = "#/?keyword=" + tmp_keyword;
	  }
	}
});

