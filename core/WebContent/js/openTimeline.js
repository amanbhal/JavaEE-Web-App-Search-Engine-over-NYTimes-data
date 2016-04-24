function show(headline,leadpara,five,four,three,two,one,docID,date,author){
			var xhttp = new XMLHttpRequest();
		    xhttp.open("GET", "updateClick?docID="+docID, true);
		    xhttp.send();
			document.getElementById("childNode").style.visibility = "visible";
			if(author){
				document.getElementById("showAuthor").style.visibility = "visible";
				var div = document.getElementById("author");
				div.innerHTML = "";
				var auth = document.createTextNode(author);
				div.appendChild(auth);
			}
			//var div1 = document.getElementById("modal-title");
			//var div2 = document.getElementById("modal-body");
			var div1 = document.getElementById("headline");
			var div2 = document.getElementById("leadpara");
			var div3 = document.getElementById("5_star_user");
			var div4 = document.getElementById("4_star_user");
			var div5 = document.getElementById("3_star_user");
			var div6 = document.getElementById("2_star_user");
			var div7 = document.getElementById("1_star_user");
			var div8 = document.getElementById("docID");
			var div9 = document.getElementById("date");
			div1.innerHTML = "";
			div2.innerHTML = "";
			div3.innerHTML = "";
			div4.innerHTML = "";
			div5.innerHTML = "";
			div6.innerHTML = "";
			div7.innerHTML = "";
			div8.innerHTML = "";
			div9.innerHTML = "";
			var headlineText = document.createTextNode(headline);
			var leadparaText = document.createTextNode(leadpara);
			var rating5 = document.createTextNode(" "+five+" Users");
			var rating4 = document.createTextNode(four+" Users");
			var rating3 = document.createTextNode(three+" Users");
			var rating2 = document.createTextNode(two+" Users");
			var rating1 = document.createTextNode(one+" Users");
			var di = document.createTextNode(docID);
			var d = document.createTextNode(date);
			div1.appendChild(headlineText);
			div2.appendChild(leadparaText);
			div3.appendChild(rating5);
			div4.appendChild(rating4);
			div5.appendChild(rating3);
			div6.appendChild(rating2);
			div7.appendChild(rating1);
			div8.appendChild(di);
			div9.appendChild(d);
			$("#stars-5").rating();
			$("#stars-4").rating();
			$("#stars-3").rating();
			$("#stars-2").rating();
			$("#stars-1").rating();
		}
		function hide() {
			document.getElementById("childNode").style.visibility = "hidden";
			if(document.getElementById("showAuthor").style.visibility == "visible"){
				document.getElementById("showAuthor").style.visibility = "hidden";
			}
		}

var __slice = [].slice;

(function($, window) {
  var Starrr;

  Starrr = (function() {
    Starrr.prototype.defaults = {
      rating: void 0,
      numStars: 5,
      change: function(e, value) {}
    };

    function Starrr($el, options) {
      var i, _, _ref,
        _this = this;

      this.options = $.extend({}, this.defaults, options);
      this.$el = $el;
      _ref = this.defaults;
      for (i in _ref) {
        _ = _ref[i];
        if (this.$el.data(i) != null) {
          this.options[i] = this.$el.data(i);
        }
      }
      this.createStars();
      this.syncRating();
      this.$el.on('mouseover.starrr', 'span', function(e) {
        return _this.syncRating(_this.$el.find('span').index(e.currentTarget) + 1);
      });
      this.$el.on('mouseout.starrr', function() {
        return _this.syncRating();
      });
      this.$el.on('click.starrr', 'span', function(e) {
        return _this.setRating(_this.$el.find('span').index(e.currentTarget) + 1);
      });
      this.$el.on('starrr:change', this.options.change);
    }

    Starrr.prototype.createStars = function() {
      var _i, _ref, _results;

      _results = [];
      for (_i = 1, _ref = this.options.numStars; 1 <= _ref ? _i <= _ref : _i >= _ref; 1 <= _ref ? _i++ : _i--) {
        _results.push(this.$el.append("<span class='glyphicon .glyphicon-star-empty'></span>"));
      }
      return _results;
    };

    Starrr.prototype.setRating = function(rating) {
      if (this.options.rating === rating) {
        rating = void 0;
      }
      this.options.rating = rating;
      this.syncRating();
      return this.$el.trigger('starrr:change', rating);
    };

    Starrr.prototype.syncRating = function(rating) {
      var i, _i, _j, _ref;

      rating || (rating = this.options.rating);
      if (rating) {
        for (i = _i = 0, _ref = rating - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          this.$el.find('span').eq(i).removeClass('glyphicon-star-empty').addClass('glyphicon-star');
        }
      }
      if (rating && rating < 5) {
        for (i = _j = rating; rating <= 4 ? _j <= 4 : _j >= 4; i = rating <= 4 ? ++_j : --_j) {
          this.$el.find('span').eq(i).removeClass('glyphicon-star').addClass('glyphicon-star-empty');
        }
      }
      if (!rating) {
        return this.$el.find('span').removeClass('glyphicon-star').addClass('glyphicon-star-empty');
      }
    };

    return Starrr;

  })();
  return $.fn.extend({
    starrr: function() {
      var args, option;

      option = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.each(function() {
        var data;

        data = $(this).data('star-rating');
        if (!data) {
          $(this).data('star-rating', (data = new Starrr($(this), option)));
        }
        if (typeof option === 'string') {
          return data[option].apply(data, args);
        }
      });
    }
  });
})(window.jQuery, window);

$(function() {
  return $(".starrr").starrr();
});

$( document ).ready(function() {
      
  $('#stars').on('starrr:change', function(e, value){
	  //alert(value);
	  var docID = $("#docID").text();
	  var xhttp = new XMLHttpRequest();
	  xhttp.open("GET", "updateRating?docID="+docID+"&rating="+value, true);
	  xhttp.send();
	  //$('#count').html(value);
  });
  
  $('#stars-existing').on('starrr:change', function(e, value){
	  //alert(value);
	  var docID = $("#docID").text();
	  var xhttp = new XMLHttpRequest();
	  xhttp.open("GET", "updateRating?docID="+docID+"&rating="+value, true);
	  xhttp.send();
	  //$('#count-existing').html(value);
  });
});

//the $(document).ready() function is down at the bottom

(function ( $ ) {
 
    $.fn.rating = function( method, options ) {
		method = method || 'create';
        // This is the easiest way to have default options.
        var settings = $.extend({
            // These are the defaults.
			limit: 5,
			value: 2,
			glyph: "glyphicon-star",
            coloroff: "gray",
			coloron: "gold",
			size: "1.0em",
			cursor: "default",
			onClick: function () {},
            endofarray: "idontmatter"
        }, options );
		var style = "";
		style = style + "font-size:" + settings.size + "; ";
		style = style + "color:" + settings.coloroff + "; ";
		style = style + "cursor:" + settings.cursor + "; ";
	

		
		if (method == 'create')
		{
			this.html('');	//junk whatever was there
			
			//initialize the data-rating property
			this.each(function(){
				attr = $(this).attr('data-rating');
				if (attr === undefined || attr === false) { $(this).attr('data-rating',settings.value); }
			})
			
			//bolt in the glyphs
			for (var i = 0; i < settings.limit; i++)
			{
				this.append('<span data-value="' + (i+1) + '" class="ratingicon glyphicon ' + settings.glyph + '" style="' + style + '" aria-hidden="true"></span>');
			}
			
			//paint
			this.each(function() { paint($(this)); });

		}
		if (method == 'set')
		{
			this.attr('data-rating',options);
			this.each(function() { paint($(this)); });
		}
		if (method == 'get')
		{
			return this.attr('data-rating');
		}
		//register the click events
		this.find("span.ratingicon").click(function() {
			rating = $(this).attr('data-value')
			$(this).parent().attr('data-rating',rating);
			paint($(this).parent());
			settings.onClick.call( $(this).parent() );
		})
		function paint(div)
		{
			rating = parseInt(div.attr('data-rating'));
			div.find("input").val(rating);	//if there is an input in the div lets set it's value
			div.find("span.ratingicon").each(function(){	//now paint the stars
				
				var rating = parseInt($(this).parent().attr('data-rating'));
				var value = parseInt($(this).attr('data-value'));
				if (value > rating) { $(this).css('color',settings.coloroff); }
				else { $(this).css('color',settings.coloron); }
			})
		}

    };
 
}( jQuery ));
//
//$(document).ready(function(){
//
//	$("#stars-default").rating();
//});
