// Blend 2.3 for jQuery 1.3+
// Copyright (c) 2011 Jack Moore - jack@colorpowered.com
// License: http://www.opensource.org/licenses/mit-license.php
(function(a,b){var c=a.fn.blend=function(c,d){var e=this,f="background",g="padding",h=[f+"Color",f+"Image",f+"Repeat",f+"Attachment",f+"Position",f+"PositionX",f+"PositionY"];return c=c||a.fn.blend.speed,d=d||a.fn.blend.callback,e[0]&&!e.is(".jQblend")&&e.each(function(){var e='<span style="position:absolute;top:0;bottom:0;left:0;right:0;"/>',f='<span style="position:relative;"/>',g=a(f)[0],i=a(e)[0],j=this,k=j.currentStyle||b.getComputedStyle(j,null),l,m;a(j).css("position")!=="absolute"&&(j.style.position="relative");for(m=0;l=h[m];m++)l in k&&(i.style[l]=g.style[l]=k[l]);g.style.backgroundImage=g.style.backgroundColor="",a(j).wrapInner(g).addClass("hover jQblend").prepend(i).hover(function(b){a(i).stop().fadeTo(c,0,function(){a.isFunction(d)&&d()})},function(b){a(i).stop().fadeTo(c,1)})}),e};c.speed=350,c.callback=!1})(jQuery,this);