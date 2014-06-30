angular.module("animefolio").factory("http", ["$http", "$rootScope", function ($http, $rootScope){
	var HOST = "http://127.0.0.1:3000";
	function http (url, method, data, success_fn, error_fn) {
		$http({
			url: url,
			method: method,
			data: data,
			withCredentials: true,
			header: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
		})
		.success(success_fn)
		.error(error_fn);
	}

	return {
		getFilms: function (scope_api, page_num, scope_status, pagenation, letter) {
			var url;
			if(letter){
				url = HOST + "/films?page_num=" + page_num + "&letter=" + letter
			}
			else{
				url = HOST + "/films?page_num=" + page_num
			}
			http(url, "GET", {},
				function (data, status, headers, config) {
					angular.forEach(data.films, function (film) {
						scope_api.films.push(film);
					});
					console.log(scope_api);
					scope_status.loading = false;

					if(data.films.length != 0){
						$(window).bind("scroll", pagenation);
					}

				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		}
	}
}])