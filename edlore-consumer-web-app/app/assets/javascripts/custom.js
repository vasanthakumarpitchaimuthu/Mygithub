/********Custom js start  ************/

$(document).ready(function(){

	/**** sign in js start *******/
	$('.signin').click(function(){
		$('.login-page,.mask').slideDown();
	});
	$('.log-sign-in').click(function(){
	$('.login-page,.mask').hide();
	});	

	/*** custom select box js start *****/
	$(".custom-select").each(function(){
		$(this).wrap("<span class='select-wrapper'></span>");
		$(this).after("<span class='holder'></span>");
	});
	$(".custom-select").change(function(){
		var selectedOption = $(this).find(":selected").text();
		$(this).next(".holder").text(selectedOption);
	}).trigger('change');
	/*** custom select box js end *****/
		/*** accordion js start  ***/
	$('.accordion-cont').hide();
	$('.accordion:first-child .accordion-cont').show();
	$('.accordion .user-cmt').click(function(){
		$('.accordion-cont').slideUp();
		$('.accordion .user-cmt').removeClass('active');
		if($(this).parent().find('.accordion-cont').is(":visible"))
		{
			$(this).parent().find('.accordion-cont').slideUp();
		}
		else {
			$(this).parent().find('.accordion-cont').slideDown();
			$(this).addClass('active');
		}
	});
	/*** accordion js end  ***/
	/*** notification popup js start***/
	$('.notification-sect').hide();
	$('a.notification').click(function(e){
		$('.notification-sect').toggle();
	});
	$('body').click(function(){
		$('.notification-sect ,.global-search-sec input, .global-search-sec .search-close').hide();
		$('.global-search-sec .global-search').show();
	});
	$('a.notification, .notification-sect, .global-search-sec .global-search, .global-search-sec input').click(function(e){
		e.stopPropagation();
	});
	/*** notification popup js end***/
	
	/*** search box popup js start***/
	$('.global-search-sec input, .global-search-sec .search-close').hide();
	$('.global-search-sec .global-search').click(function(){
		$('.global-search-sec input, .global-search-sec .search-close').show();
		$('.global-search-sec .global-search').hide();
	});
	$('.global-search-sec .search-close').click(function(){
		$('.global-search-sec input, .global-search-sec .search-close').hide();
		$('.global-search-sec .global-search').show();
	});
	/*** search box popup js end***/
	/***Profile popup js start***/
		$(".profile-info").on("click", function(){
			$(".profile-list").toggle();
		});
		 $('.profile-list, .profile-info').on("click",function(e1){
			e1.stopPropagation();
		 }); 
		$('body').click(function(e){
			$('.profile-list').hide();
		});
		$('.comm-table a.detail').click(function(){
			$('.mask,.static-details-popup').show();
		});
		$('.pop-up-close').click(function(){
			$('.mask,.static-details-popup').hide();
		});
		/***Profile popup js end***/
		/**** accordion js start *******/
		$('.acc_content').slideUp();
		$('.acc_head').click(function(){
			$('.acc_content').slideUp();
			$('.acc_head').removeClass('acc_active');
			if($(this).next('.acc_content').is(":visible"))
			{
			$(this).next('.acc_content').slideUp();
			}
			else {
				$(this).next('.acc_content').slideDown();
				$(this).addClass('acc_active');
			}
		});
		
		/********Custom js end ************/
		var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");	
});
		

	