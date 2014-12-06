/**
 * nmcDropDown plugin - v1.0.4
 * Author: Eli Van Zoeren
 * Copyright (c) 2009 New Media Campaigns
 * http://www.newmediacampaigns.com
 * ---------------------------------------------
 * Usage: $('#nav').nmcDropDown({[options]});
 *
 * See below for configuration options. If you
 * don't pass in any options, the plugin will
 * Use reasonable defaults.
 *
 * Dependancy: jQuery 1.2.6+
 * Optional depenancy: hoverIntent plugin
 *   http://cherne.net/brian/resources/jquery.hoverIntent.html
 **/
(function($) {

    $.fn.nmcDropDown = function(options) {

        // build main options before element iteration
        var opts = $.extend({}, $.fn.nmcDropDown.defaults, options);

        // iterate each matched element
        return this.each(function() {
            var menu = $(this);
            submenus = menu.children('li:has('+opts.submenu_selector+')');

            if (opts.fix_IE) {
                // Fix IE 6+7 z-index bug
                menu.css('z-index', 51)
                    .parents().each(function(i) {
                        if ($(this).css('position') == 'relative') {
                            $(this).css('z-index', (i + 52));
                        }
                    });
                submenus.children(opts.submenu_selector).css('z-index', 50);
            }

            // Function that is called to show the submenu
            over = function() {
                $(this).addClass(opts.active_class)
                       .children(opts.submenu_selector).animate(opts.show, opts.show_speed);
                return false;
            }

            // Function that is called to hide the submenu
            out = function() {
                $(this).removeClass(opts.active_class)
                       .children(opts.submenu_selector).animate(opts.hide, opts.hide_speed);
                return false;
            }

            // Show and hide the sub-menus
            if (opts.trigger == 'click') {
                submenus
                    .toggle(over, out)
                    .children(opts.submenu_selector).hide();
            } else if ($().hoverIntent) {
                submenus
                    .hoverIntent({
                        interval: opts.show_delay,
                        over: over,
                        timeout: opts.hide_delay,
                        out: out
                    }).children(opts.submenu_selector).hide();
            } else {
                submenus
                    .hover(over, out)
                    .children(opts.submenu_selector).hide();
            }
        });
    };

    // Default options
    $.fn.nmcDropDown.defaults = {
        trigger: 'hover',           // Event to show and hide sub-menu - hover or click
        active_class: 'open',       // Class to give open menu items
        submenu_selector: 'ul',     // The element immediately below the <li> containing the sub-menu
        show: {opacity: 'show'},    // Effect(s) to use when showing the sub-menu
        show_speed: 300,            // Speed of the show transition
        show_delay: 50,             // Delay before the sub-menu is show (requires HoverIntent)
        hide: {opacity: 'hide'},    // Effect(s) to use when hiding the sub-menu
        hide_speed: 200,            // Speed of the hide transition
        hide_delay: 100,            // Delay before the sub-menu is hidden (requires HoverIntent)
        fix_IE: true                // IE 6 and 7 have problems with z-indexes. This tries to fix them
    };

})(jQuery);