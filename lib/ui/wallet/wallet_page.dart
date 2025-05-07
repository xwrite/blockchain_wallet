import 'dart:collection';

import 'package:blockchain_wallet/common/extension/functions_extension.dart';
import 'package:blockchain_wallet/data/app_preferences.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'wallet_controller.dart';
import 'wallet_state.dart';


class Site {
  final String name; // 站点名称
  final String url; // 站点URL
  final int level; // 站点优先级/级别

  const Site({required this.name, required this.url, required this.level});

  // 根据level获取站点状态文本
  String get statusText {
    switch (level) {
      case 0:
        return "主站";
      case 1:
        return "优先";
      default:
        return "备用";
    }
  }

  // 根据level获取站点状态颜色
  Color get statusColor {
    switch (level) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(name: json['name'], url: json['url'], level: json['level']);
  }
}



final sites = <Site>[
  const Site(name: "毒舌主站JD", url: "https://m.baidu.com", level: 0),
  const Site(name: "毒舌主站", url: "https://a.duse0.com:51111", level: 0),
  const Site(name: "毒舌备用站1", url: "https://a.duse1.com:51111", level: 1),
  const Site(name: "毒舌备用站2", url: "https://a.duse2.com:51111", level: 1),
  const Site(name: "毒舌备用站3", url: "https://a.duse3.com:51111", level: 1),
  const Site(name: "毒舌备用站4", url: "https://a.duse4.com:51111", level: 2),
  const Site(name: "毒舌备用站5", url: "https://a.duse5.com:51111", level: 2),
];


final snifferScript = r'''
!function(){"use strict";class t{constructor(t,e={}){this.snv=t,this.fn=t.fn,this.Log=t.Log,this.options={cacheEnabled:!0,cachePrefix:"video:",fetchVideoInfo:()=>({}),fetchVariants:()=>[],fetchChapters:()=>[],fetchPlayState:()=>({currentChapter:0,currentVariant:0}),onSwitchVariant:t=>t,onSwitchChapter:t=>t,checkIsPlayPage:()=>!0,checkShouldSniff:t=>this.fn.isVideoResource(t),onStartSniffing:()=>{},onFinishSniffing:()=>this.fn.stopVideo(this.snv),onDestroy:()=>{},...e}}#t=(t,e,n=!1)=>{const{options:r,fn:i,Log:o}=this,s=`${r.cachePrefix}:${t}`;if(r.cacheEnabled&&!n){const t=i.getCache(s);if(t)return t}const a=e();return r.cacheEnabled&&a&&(Array.isArray(a)?a.length>0&&i.setCache(s,a):i.setCache(s,a)),a};getVideoInfo=(t=!1)=>this.#t("info",(()=>this.options.fetchVideoInfo()),t);getVariants=(t=!1)=>this.#t("variants",(()=>this.options.fetchVariants()),t);getChapters=(t=!1)=>this.#t("chapters",(()=>this.options.fetchChapters(t)),t);getPlayState=(t=!1)=>this.options.fetchPlayState();switchVariant=t=>{const e=`${this.options.cachePrefix}:chapters`;this.options.onSwitchVariant(t),this.fn.clearCache([e])};switchChapter=t=>this.options.onSwitchChapter(t);isOnPlayPage=()=>this.options.checkIsPlayPage();startSniffing=()=>(this.Log.i("sniffer","启动视频嗅探"),this.snv.dispatcher.emit(this.snv.Events.SYNC_DATA),this.options.onStartSniffing());shouldSniff=t=>this.options.checkShouldSniff(t);finishSniffing=()=>(this.Log.i("sniffer","完成视频嗅探"),this.options.onFinishSniffing());reset=()=>{this.Log.i("sniffer","开始清空剧集缓存"),this.fn.clearCache()};destroy=()=>{this.fn.clearCache(),this.options.onDestroy()}}class e{#e=null;#n=null;constructor(){if(e.instance)return e.instance;e.instance=this}initDefaultSniffer(){this.#n||(this.#n=new t(this))}#r(t){return(...e)=>{const n=this.#e||this.#n;return n?t.apply(n,e):null}}videoSniffer(t){t&&(this.#e=t)}getVariants=this.#r((function(t=!1){return JSON.stringify(this.getVariants(t))}));syncVariants(t){const e="string"==typeof t?t:JSON.stringify(t);this.fn.callFlutterHandler("sync_video_data","sync_variants",e)}getChapters=this.#r((function(t=!1){return JSON.stringify(this.getChapters(t))}));syncChapters(t){const e="string"==typeof t?t:JSON.stringify(t);this.fn.callFlutterHandler("sync_video_data","sync_chapters",e)}getPlayState=this.#r((function(){return JSON.stringify(this.getPlayState())}));syncPlayState(t){const e="string"==typeof t?t:JSON.stringify(t);this.fn.callFlutterHandler("sync_video_data","sync_play_state",e)}reset(){this.#r((function(){this.reset()}))(),this.fn.callFlutterHandler("reset")}switchVariant=this.#r((function(t){return this.switchVariant(t)}));switchChapter=this.#r((function(t){return this.switchChapter(t)}));isOnPlayPage=this.#r((function(){return this.isOnPlayPage()}));startSniffing=this.#r((function(){return this.startSniffing()}));shouldSniff=this.#r((function(t){return this.shouldSniff(t)}));finishSniffing=this.#r((function(){return this.finishSniffing()}))}"undefined"!=typeof globalThis?globalThis:"undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!=typeof self&&self;function n(t,e){return t(e={exports:{}},e.exports),e.exports}var r=n((function(t,e){!function(){var e=document,n=window,r=e.documentElement,i=e.createElement.bind(e),o=i("div"),s=i("table"),a=i("tbody"),c=i("tr"),u=Array.isArray,f=Array.prototype,h=f.concat,l=f.filter,d=f.indexOf,p=f.map,v=f.push,g=f.slice,y=f.some,m=f.splice,w=/^#(?:[\w-]|\\.|[^\x00-\xa0])*$/,S=/^\.(?:[\w-]|\\.|[^\x00-\xa0])*$/,b=/<.+>/,_=/^\w+$/;function E(t,e){var n,r=!!(n=e)&&11===n.nodeType;return t&&(r||L(e)||T(e))?!r&&S.test(t)?e.getElementsByClassName(t.slice(1).replace(/\\/g,"")):!r&&_.test(t)?e.getElementsByTagName(t):e.querySelectorAll(t):[]}var C=function(){function t(t,r){if(t){if(x(t))return t;var i=t;if(P(t)){var o=r||e;if(!(i=w.test(t)&&L(o)?o.getElementById(t.slice(1).replace(/\\/g,"")):b.test(t)?X(t):x(o)?o.find(t):P(o)?O(o).find(t):E(t,o)))return}else if(N(t))return this.ready(t);(i.nodeType||i===n)&&(i=[i]),this.length=i.length;for(var s=0,a=this.length;s<a;s++)this[s]=i[s]}}return t.prototype.init=function(e,n){return new t(e,n)},t}(),A=C.prototype,O=A.init;function x(t){return t instanceof C}function R(t){return!!t&&t===t.window}function L(t){return!!t&&9===t.nodeType}function T(t){return!!t&&1===t.nodeType}function N(t){return"function"==typeof t}function P(t){return"string"==typeof t}function D(t){return void 0===t}function H(t){return null===t}function I(t){return!isNaN(parseFloat(t))&&isFinite(t)}function V(t){if("object"!=typeof t||null===t)return!1;var e=Object.getPrototypeOf(t);return null===e||e===Object.prototype}function j(t,e,n){if(n){for(var r=t.length;r--;)if(!1===e.call(t[r],r,t[r]))return t}else if(V(t))for(var i=Object.keys(t),o=(r=0,i.length);r<o;r++){var s=i[r];if(!1===e.call(t[s],s,t[s]))return t}else for(r=0,o=t.length;r<o;r++)if(!1===e.call(t[r],r,t[r]))return t;return t}function U(){for(var t=[],e=0;e<arguments.length;e++)t[e]=arguments[e];var n="boolean"==typeof t[0]&&t.shift(),r=t.shift(),i=t.length;if(!r)return{};if(!i)return U(n,O,r);for(var o=0;o<i;o++){var s=t[o];for(var a in s)n&&(u(s[a])||V(s[a]))?(r[a]&&r[a].constructor===s[a].constructor||(r[a]=new s[a].constructor),U(n,r[a],s[a])):r[a]=s[a]}return r}O.fn=O.prototype=A,A.length=0,A.splice=m,"function"==typeof Symbol&&(A[Symbol.iterator]=f[Symbol.iterator]),O.isWindow=R,O.isFunction=N,O.isArray=u,O.isNumeric=I,O.isPlainObject=V,O.each=j,A.each=function(t){return j(this,t)},A.empty=function(){return this.each((function(t,e){for(;e.firstChild;)e.removeChild(e.firstChild)}))},O.extend=U,A.extend=function(t){return U(A,t)};var F=/\S+/g;function k(t){return P(t)&&t.match(F)||[]}function $(t,e,r){if(T(t)){var i=n.getComputedStyle(t,null);return r?i.getPropertyValue(e)||void 0:i[e]||t.style[e]}}function B(t,e){return parseInt($(t,e),10)||0}function M(t,e){return B(t,"border".concat(e?"Left":"Top","Width"))+B(t,"padding".concat(e?"Left":"Top"))+B(t,"padding".concat(e?"Right":"Bottom"))+B(t,"border".concat(e?"Right":"Bottom","Width"))}A.toggleClass=function(t,e){var n=k(t),r=!D(e);return this.each((function(t,i){T(i)&&j(n,(function(t,n){r?e?i.classList.add(n):i.classList.remove(n):i.classList.toggle(n)}))}))},A.addClass=function(t){return this.toggleClass(t,!0)},A.removeAttr=function(t){var e=k(t);return this.each((function(t,n){T(n)&&j(e,(function(t,e){n.removeAttribute(e)}))}))},A.attr=function(t,e){if(t){if(P(t)){if(arguments.length<2){if(!this[0]||!T(this[0]))return;var n=this[0].getAttribute(t);return H(n)?void 0:n}return D(e)?this:H(e)?this.removeAttr(t):this.each((function(n,r){T(r)&&r.setAttribute(t,e)}))}for(var r in t)this.attr(r,t[r]);return this}},A.removeClass=function(t){return arguments.length?this.toggleClass(t,!1):this.attr("class","")},A.hasClass=function(t){return!!t&&y.call(this,(function(e){return T(e)&&e.classList.contains(t)}))},A.get=function(t){return D(t)?g.call(this):this[(t=Number(t))<0?t+this.length:t]},A.eq=function(t){return O(this.get(t))},A.first=function(){return this.eq(0)},A.last=function(){return this.eq(-1)},A.text=function(t){return D(t)?this.get().map((function(t){return T(t)||(e=t)&&3===e.nodeType?t.textContent:"";var e})).join(""):this.each((function(e,n){T(n)&&(n.textContent=t)}))};var W={};function z(t){return"none"===$(t,"display")}function J(t,e){var n=t&&(t.matches||t.webkitMatchesSelector||t.msMatchesSelector);return!!n&&!!e&&n.call(t,e)}function q(t){return P(t)?function(e,n){return J(n,t)}:N(t)?t:x(t)?function(e,n){return t.is(n)}:t?function(e,n){return n===t}:function(){return!1}}function Y(t,e){return e?t.filter(e):t}A.filter=function(t){var e=q(t);return O(l.call(this,(function(t,n){return e.call(t,n,t)})))},A.detach=function(t){return Y(this,t).each((function(t,e){e.parentNode&&e.parentNode.removeChild(e)})),this};var G=/^\s*<(\w+)[^>]*>/,Q=/^<(\w+)\s*\/?>(?:<\/\1>)?$/,K={"*":o,tr:a,td:c,th:c,thead:s,tbody:s,tfoot:s};function X(t){if(!P(t))return[];if(Q.test(t))return[i(RegExp.$1)];var e=G.test(t)&&RegExp.$1,n=K[e]||K["*"];return n.innerHTML=t,O(n.childNodes).detach().get()}function Z(t,e,n,r){for(var i=[],o=N(e),s=r&&q(r),a=0,c=t.length;a<c;a++)if(o){var u=e(t[a]);u.length&&v.apply(i,u)}else for(var f=t[a][e];!(null==f||r&&s(-1,f));)i.push(f),f=n?f[e]:null;return i}function tt(t){return t.multiple&&t.options?Z(l.call(t.options,(function(t){return t.selected&&!t.disabled&&!t.parentNode.disabled})),"value"):t.value||""}function et(t){return t.length>1?l.call(t,(function(t,e,n){return d.call(n,t)===e})):t}O.parseHTML=X,A.has=function(t){var e=P(t)?function(e,n){return E(t,n).length}:function(e,n){return n.contains(t)};return this.filter(e)},A.not=function(t){var e=q(t);return this.filter((function(n,r){return(!P(t)||T(r))&&!e.call(r,n,r)}))},A.val=function(t){return arguments.length?this.each((function(e,n){var r=n.multiple&&n.options;if(r||Dt.test(n.type)){var i=u(t)?p.call(t,String):H(t)?[]:[String(t)];r?j(n.options,(function(t,e){e.selected=i.indexOf(e.value)>=0}),!0):n.checked=i.indexOf(n.value)>=0}else n.value=D(t)||H(t)?"":t})):this[0]&&tt(this[0])},A.is=function(t){var e=q(t);return y.call(this,(function(t,n){return e.call(t,n,t)}))},O.guid=1,O.unique=et,A.add=function(t,e){return O(et(this.get().concat(O(t,e).get())))},A.children=function(t){return Y(O(et(Z(this,(function(t){return t.children})))),t)},A.parent=function(t){return Y(O(et(Z(this,"parentNode"))),t)},A.index=function(t){var e=t?O(t)[0]:this[0],n=t?this:O(e).parent().children();return d.call(n,e)},A.closest=function(t){var e=this.filter(t);if(e.length)return e;var n=this.parent();return n.length?n.closest(t):e},A.siblings=function(t){return Y(O(et(Z(this,(function(t){return O(t).parent().children().not(t)})))),t)},A.find=function(t){return O(et(Z(this,(function(e){return E(t,e)}))))};var nt=/^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g,rt=/^$|^module$|\/(java|ecma)script/i,it=["type","src","nonce","noModule"];function ot(t,e,n,o,s){o?t.insertBefore(e,n?t.firstChild:null):"HTML"===t.nodeName?t.parentNode.replaceChild(e,t):t.parentNode.insertBefore(e,n?t:t.nextSibling),s&&function(t,e){var n=O(t);n.filter("script").add(n.find("script")).each((function(t,n){if(rt.test(n.type)&&r.contains(n)){var o=i("script");o.text=n.textContent.replace(nt,""),j(it,(function(t,e){n[e]&&(o[e]=n[e])})),e.head.insertBefore(o,null),e.head.removeChild(o)}}))}(e,t.ownerDocument)}function st(t,e,n,r,i,o,s,a){return j(t,(function(t,o){j(O(o),(function(t,o){j(O(e),(function(e,s){var a=n?s:o,c=n?t:e;ot(n?o:s,c?a.cloneNode(!0):a,r,i,!c)}),a)}),s)}),o),e}A.after=function(){return st(arguments,this,!1,!1,!1,!0,!0)},A.append=function(){return st(arguments,this,!1,!1,!0)},A.html=function(t){if(!arguments.length)return this[0]&&this[0].innerHTML;if(D(t))return this;var e=/<script[\s>]/.test(t);return this.each((function(n,r){T(r)&&(e?O(r).empty().append(t):r.innerHTML=t)}))},A.appendTo=function(t){return st(arguments,this,!0,!1,!0)},A.wrapInner=function(t){return this.each((function(e,n){var r=O(n),i=r.contents();i.length?i.wrapAll(t):r.append(t)}))},A.before=function(){return st(arguments,this,!1,!0)},A.wrapAll=function(t){for(var e=O(t),n=e[0];n.children.length;)n=n.firstElementChild;return this.first().before(e),this.appendTo(n)},A.wrap=function(t){return this.each((function(e,n){var r=O(t)[0];O(n).wrapAll(e?r.cloneNode(!0):r)}))},A.insertAfter=function(t){return st(arguments,this,!0,!1,!1,!1,!1,!0)},A.insertBefore=function(t){return st(arguments,this,!0,!0)},A.prepend=function(){return st(arguments,this,!1,!0,!0,!0,!0)},A.prependTo=function(t){return st(arguments,this,!0,!0,!0,!1,!1,!0)},A.contents=function(){return O(et(Z(this,(function(t){return"IFRAME"===t.tagName?[t.contentDocument]:"TEMPLATE"===t.tagName?t.content.childNodes:t.childNodes}))))},A.next=function(t,e,n){return Y(O(et(Z(this,"nextElementSibling",e,n))),t)},A.nextAll=function(t){return this.next(t,!0)},A.nextUntil=function(t,e){return this.next(e,!0,t)},A.parents=function(t,e){return Y(O(et(Z(this,"parentElement",!0,e))),t)},A.parentsUntil=function(t,e){return this.parents(e,t)},A.prev=function(t,e,n){return Y(O(et(Z(this,"previousElementSibling",e,n))),t)},A.prevAll=function(t){return this.prev(t,!0)},A.prevUntil=function(t,e){return this.prev(e,!0,t)},A.map=function(t){return O(h.apply([],p.call(this,(function(e,n){return t.call(e,n,e)}))))},A.clone=function(){return this.map((function(t,e){return e.cloneNode(!0)}))},A.offsetParent=function(){return this.map((function(t,e){for(var n=e.offsetParent;n&&"static"===$(n,"position");)n=n.offsetParent;return n||r}))},A.slice=function(t,e){return O(g.call(this,t,e))};var at=/-([a-z])/g;function ct(t){return t.replace(at,(function(t,e){return e.toUpperCase()}))}A.ready=function(t){var n=function(){return setTimeout(t,0,O)};return"loading"!==e.readyState?n():e.addEventListener("DOMContentLoaded",n),this},A.unwrap=function(){return this.parent().each((function(t,e){if("BODY"!==e.tagName){var n=O(e);n.replaceWith(n.children())}})),this},A.offset=function(){var t=this[0];if(t){var e=t.getBoundingClientRect();return{top:e.top+n.pageYOffset,left:e.left+n.pageXOffset}}},A.position=function(){var t=this[0];if(t){var e="fixed"===$(t,"position"),n=e?t.getBoundingClientRect():this.offset();if(!e){for(var r=t.ownerDocument,i=t.offsetParent||r.documentElement;(i===r.body||i===r.documentElement)&&"static"===$(i,"position");)i=i.parentNode;if(i!==t&&T(i)){var o=O(i).offset();n.top-=o.top+B(i,"borderTopWidth"),n.left-=o.left+B(i,"borderLeftWidth")}}return{top:n.top-B(t,"marginTop"),left:n.left-B(t,"marginLeft")}}};var ut={class:"className",contenteditable:"contentEditable",for:"htmlFor",readonly:"readOnly",maxlength:"maxLength",tabindex:"tabIndex",colspan:"colSpan",rowspan:"rowSpan",usemap:"useMap"};A.prop=function(t,e){if(t){if(P(t))return t=ut[t]||t,arguments.length<2?this[0]&&this[0][t]:this.each((function(n,r){r[t]=e}));for(var n in t)this.prop(n,t[n]);return this}},A.removeProp=function(t){return this.each((function(e,n){delete n[ut[t]||t]}))};var ft=/^--/;function ht(t){return ft.test(t)}var lt={},dt=o.style,pt=["webkit","moz","ms"];var vt={animationIterationCount:!0,columnCount:!0,flexGrow:!0,flexShrink:!0,fontWeight:!0,gridArea:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnStart:!0,gridRow:!0,gridRowEnd:!0,gridRowStart:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,widows:!0,zIndex:!0};function gt(t,e,n){return void 0===n&&(n=ht(t)),n||vt[t]||!I(e)?e:"".concat(e,"px")}function yt(t,e){try{return t(e)}catch(t){return e}}A.css=function(t,e){if(P(t)){var n=ht(t);return t=function(t,e){if(void 0===e&&(e=ht(t)),e)return t;if(!lt[t]){var n=ct(t),r="".concat(n[0].toUpperCase()).concat(n.slice(1));j("".concat(n," ").concat(pt.join("".concat(r," "))).concat(r).split(" "),(function(e,n){if(n in dt)return lt[t]=n,!1}))}return lt[t]}(t,n),arguments.length<2?this[0]&&$(this[0],t,n):t?(e=gt(t,e,n),this.each((function(r,i){T(i)&&(n?i.style.setProperty(t,e):i.style[t]=e)}))):this}for(var r in t)this.css(r,t[r]);return this};var mt=/^\s+|\s+$/;function wt(t,e){var n=t.dataset[e]||t.dataset[ct(e)];return mt.test(n)?n:yt(JSON.parse,n)}function St(t,e){var n=t.documentElement;return Math.max(t.body["scroll".concat(e)],n["scroll".concat(e)],t.body["offset".concat(e)],n["offset".concat(e)],n["client".concat(e)])}A.data=function(t,e){if(!t){if(!this[0])return;var n={};for(var r in this[0].dataset)n[r]=wt(this[0],r);return n}if(P(t))return arguments.length<2?this[0]&&wt(this[0],t):D(e)?this:this.each((function(n,r){!function(t,e,n){n=yt(JSON.stringify,n),t.dataset[ct(e)]=n}(r,t,e)}));for(var r in t)this.data(r,t[r]);return this},j([!0,!1],(function(t,e){j(["Width","Height"],(function(t,n){var r="".concat(e?"outer":"inner").concat(n);A[r]=function(r){if(this[0])return R(this[0])?e?this[0]["inner".concat(n)]:this[0].document.documentElement["client".concat(n)]:L(this[0])?St(this[0],n):this[0]["".concat(e?"offset":"client").concat(n)]+(r&&e?B(this[0],"margin".concat(t?"Top":"Left"))+B(this[0],"margin".concat(t?"Bottom":"Right")):0)}}))})),j(["Width","Height"],(function(t,e){var n=e.toLowerCase();A[n]=function(r){if(!this[0])return D(r)?void 0:this;if(!arguments.length)return R(this[0])?this[0].document.documentElement["client".concat(e)]:L(this[0])?St(this[0],e):this[0].getBoundingClientRect()[n]-M(this[0],!t);var i=parseInt(r,10);return this.each((function(e,r){if(T(r)){var o=$(r,"boxSizing");r.style[n]=gt(n,i+("border-box"===o?M(r,!t):0))}}))}}));var bt="___cd";A.toggle=function(t){return this.each((function(n,r){if(T(r)){var o=z(r);(D(t)?o:t)?(r.style.display=r[bt]||"",z(r)&&(r.style.display=function(t){if(W[t])return W[t];var n=i(t);e.body.insertBefore(n,null);var r=$(n,"display");return e.body.removeChild(n),W[t]="none"!==r?r:"block"}(r.tagName))):o||(r[bt]=$(r,"display"),r.style.display="none")}}))},A.hide=function(){return this.toggle(!1)},A.show=function(){return this.toggle(!0)};var _t="___ce",Et={focus:"focusin",blur:"focusout"},Ct={mouseenter:"mouseover",mouseleave:"mouseout"},At=/^(mouse|pointer|contextmenu|drag|drop|click|dblclick)/i;function Ot(t){return Ct[t]||Et[t]||t}function xt(t){var e=t.split(".");return[e[0],e.slice(1).sort()]}function Rt(t){return t[_t]=t[_t]||{}}function Lt(t,e){return!e||!y.call(e,(function(e){return t.indexOf(e)<0}))}function Tt(t,e,n,r,i){var o=Rt(t);if(e)o[e]&&(o[e]=o[e].filter((function(o){var s=o[0],a=o[1],c=o[2];if(i&&c.guid!==i.guid||!Lt(s,n)||r&&r!==a)return!0;t.removeEventListener(e,c)})));else for(e in o)Tt(t,e,n,r,i)}A.trigger=function(t,n){if(P(t)){var r=xt(t),i=r[0],o=r[1],s=Ot(i);if(!s)return this;var a=At.test(s)?"MouseEvents":"HTMLEvents";(t=e.createEvent(a)).initEvent(s,!0,!0),t.namespace=o.join("."),t.___ot=i}t.___td=n;var c=t.___ot in Et;return this.each((function(e,n){c&&N(n[t.___ot])&&(n["___i".concat(t.type)]=!0,n[t.___ot](),n["___i".concat(t.type)]=!1),n.dispatchEvent(t)}))},A.off=function(t,e,n){var r=this;if(D(t))this.each((function(t,e){(T(e)||L(e)||R(e))&&Tt(e)}));else if(P(t))N(e)&&(n=e,e=""),j(k(t),(function(t,i){var o=xt(i),s=o[0],a=o[1],c=Ot(s);r.each((function(t,r){(T(r)||L(r)||R(r))&&Tt(r,c,a,e,n)}))}));else for(var i in t)this.off(i,t[i]);return this},A.remove=function(t){return Y(this,t).detach().off(),this},A.replaceWith=function(t){return this.before(t).remove()},A.replaceAll=function(t){return O(t).replaceWith(this),this},A.on=function(t,e,n,r,i){var o=this;if(!P(t)){for(var s in t)this.on(s,e,n,t[s],i);return this}return P(e)||(D(e)||H(e)?e="":D(n)?(n=e,e=""):(r=n,n=e,e="")),N(r)||(r=n,n=void 0),r?(j(k(t),(function(t,s){var a=xt(s),c=a[0],u=a[1],f=Ot(c),h=c in Ct,l=c in Et;f&&o.each((function(t,o){if(T(o)||L(o)||R(o)){var s=function(t){if(t.target["___i".concat(t.type)])return t.stopImmediatePropagation();if((!t.namespace||Lt(u,t.namespace.split(".")))&&(e||!(l&&(t.target!==o||t.___ot===f)||h&&t.relatedTarget&&o.contains(t.relatedTarget)))){var a=o;if(e){for(var c=t.target;!J(c,e);){if(c===o)return;if(!(c=c.parentNode))return}a=c}Object.defineProperty(t,"currentTarget",{configurable:!0,get:function(){return a}}),Object.defineProperty(t,"delegateTarget",{configurable:!0,get:function(){return o}}),Object.defineProperty(t,"data",{configurable:!0,get:function(){return n}});var d=r.call(a,t,t.___td);i&&Tt(o,f,u,e,s),!1===d&&(t.preventDefault(),t.stopPropagation())}};s.guid=r.guid=r.guid||O.guid++,function(t,e,n,r,i){var o=Rt(t);o[e]=o[e]||[],o[e].push([n,r,i]),t.addEventListener(e,i)}(o,f,u,e,s)}}))})),this):this},A.one=function(t,e,n,r){return this.on(t,e,n,r,!0)};var Nt=/\r?\n/g;var Pt=/file|reset|submit|button|image/i,Dt=/radio|checkbox/i;A.serialize=function(){var t="";return this.each((function(e,n){j(n.elements||[n],(function(e,n){if(!(n.disabled||!n.name||"FIELDSET"===n.tagName||Pt.test(n.type)||Dt.test(n.type)&&!n.checked)){var r=tt(n);if(!D(r))j(u(r)?r:[r],(function(e,r){t+=function(t,e){return"&".concat(encodeURIComponent(t),"=").concat(encodeURIComponent(e.replace(Nt,"\r\n")))}(n.name,r)}))}}))})),t.slice(1)},t.exports=O}()}));class i{isInit=!1;constructor(){r(window).on("beforeunload",this.destroy.bind(this))}init(){}destroy(){}}var o=Object.freeze({__proto__:null,callFlutterHandler:function(t,...e){return new Promise(((n,r)=>{try{window.flutter_inappwebview&&"function"==typeof window.flutter_inappwebview.callHandler?window.flutter_inappwebview.callHandler(t,...e).then((t=>{t&&t.error?r(new Error(t.error)):n(t)})).catch((t=>{r(new Error(`Flutter handler error: ${t.message}`))})):r(new Error("Flutter InAppWebView 环境未检测到"))}catch(t){r(new Error(`JavaScript 执行错误: ${t.message}`))}}))}});var s=Object.freeze({__proto__:null,getCurrentURL:()=>window.location.href,getQueryString:()=>window.location.search,parseQueryParams:(t=window.location.search)=>{const e=new URLSearchParams(t);return Object.fromEntries(e.entries())},getQueryParam:t=>new URLSearchParams(window.location.search).get(t),updateQueryParams:(t,e=!1)=>{const n=new URL(window.location.href);Object.entries(t).forEach((([t,e])=>{null==e?n.searchParams.delete(t):n.searchParams.set(t,e)}));const r=e?"replaceState":"pushState";window.history[r]({path:n.href},"",n.href)},removeQueryParams:(t,e=!1)=>{const n=new URL(window.location.href);(Array.isArray(t)?t:[t]).forEach((t=>n.searchParams.delete(t)));const r=e?"replaceState":"pushState";window.history[r]({path:n.href},"",n.href)},replaceQueryString:(t,e=!1)=>{const n=new URL(window.location.href);n.search=t;const r=e?"replaceState":"pushState";window.history[r]({path:n.href},"",n.href)},getBaseURL:()=>{const t=new URL(window.location.href);return`${t.origin}${t.pathname}`},isHTTPS:()=>"https:"===window.location.protocol,getHash:()=>window.location.hash.substring(1),updateHash:(t,e=!1)=>{const n=e?"replaceState":"pushState";window.history[n](null,"",`#${t}`)},navigateTo:(t,e=!1)=>{e?window.location.replace(t):window.location.assign(t)},changePathname:(t,e=!1)=>{const n=new URL(window.location.href);n.pathname=t.startsWith("/")?t:`/${t}`;const r=e?"replaceState":"pushState";window.history[r]({path:n.href},"",n.href)},getOrigin:()=>window.location.origin,getHost:()=>window.location.host,getHostname:()=>window.location.hostname,getPort:()=>window.location.port,containsInHostname:(t,e=!1)=>{const n=window.location.hostname;return e?n.includes(t):n.toLowerCase().includes(t.toLowerCase())},matchesHostname:t=>t.test(window.location.hostname),matchesHashPattern:t=>{const e=window.location.hash.substring(1);return t instanceof RegExp?t.test(e):e===t},getHashParam:t=>{const e=window.location.hash.substring(1),n=e.indexOf("?"),r=n>=0?e.substring(n+1):e;return new URLSearchParams(r).get(t)},matchesPathname:t=>{const e=window.location.pathname;return t instanceof RegExp?t.test(e):e===t||t.endsWith("/")&&e.startsWith(t)||(e+"/").startsWith(t+"/")},getDomainLevel:(t=2)=>{const e=window.location.hostname.split(".");return e.length>=t?e.slice(-t).join("."):null}});var a=Object.freeze({__proto__:null,getCache:function(t){const e=sessionStorage.getItem(t);return e?JSON.parse(e):null},setCache:function(t,e){sessionStorage.setItem(t,JSON.stringify(e))},clearCache:function(t=[]){if(!t.length)return void sessionStorage.clear();const e=[];for(let n=0;n<sessionStorage.length;n++){const r=sessionStorage.key(n);t.some((t=>r.startsWith(t)))&&e.push(r)}e.forEach((t=>sessionStorage.removeItem(t)))}});var c=Object.freeze({__proto__:null,isVideoResource:function(t){const e=/\.(m3u8|mpd|mp4|mkv|mov|avi|flv|wmv)(\?.*)?$/i,n=/\.(ts|m4s)(\?.*)?$|segment|chunk|frag|seq=|segment=|_\d+\.|\d+\.ts/i;try{return!n.test(t)&&e.test(t)}catch(t){return console.warn("[video-sniffer] URL 解析失败:",t),!1}},stopVideo:function(t){const e=t.$("video");if(!e.length)return;const n=()=>{e.prop("src",""),e[0].pause(),e[0].load()};e[0].readyState>=2?n():e.one("canplay",n)}}),u={...o,...s,...a,...c};class f{static#i=null;constructor(){if(f.#i)return f.#i;f.#i=this}#o(t,e,n){if("string"!=typeof t||void 0===n)return void console.error("Invalid log parameters");const r="object"==typeof n?JSON.stringify(n):n;u.callFlutterHandler("log",t,e,r).catch((r=>{console.error(`[Snv Log Failed] ${e}:${t} - ${n}`),console.error("Error details:",r)}))}e(t,e){this.#o(t,"E",e)}i(t,e){this.#o(t,"I",e)}w(t,e){this.#o(t,"W",e)}d(t,e){this.#o(t,"D",e)}v(t,e){this.#o(t,"V",e)}}var h=new f;class l extends i{constructor(t,e={}){h.i("AdFilter","开始构造AdFilter"),super(),this.selectors=e.selectors||[],this.combinedSelector=this.selectors.join(", "),this.onDetect=e.onDetect||(t=>{t.style.display="none"}),this.root=e.root||document.documentElement,this.debounceDelay=e.debounceDelay??100,this.init()}init(){try{h.i("AdFilter","开始初始化"),this.observer=new MutationObserver((t=>{t.forEach((t=>{"childList"===t.type?t.addedNodes.forEach((t=>{t.nodeType===Node.ELEMENT_NODE&&(this.checkElement(t),t.querySelectorAll("*").forEach((t=>{this.checkElement(t)})))})):"attributes"===t.type&&this.checkElement(t.target)}))}));const t={childList:!0,subtree:!0,attributes:!0,attributeFilter:["class","id","style"]};h.i("AdFilter","开始观察节点: "+(this.root?this.root.tagName:"null")),this.observer.observe(this.root,t),h.i("AdFilter","节点观察已启动"),this.checkElement(this.root)}catch(t){h.e("AdFilter","初始化失败: "+t.message)}}checkElement(t){try{if(this.matchesSelector(t))return void this.onDetect(t);t.querySelectorAll(this.combinedSelector).forEach((t=>this.onDetect(t)))}catch(t){h.e("AdFilter","检查元素失败: "+t.message)}}matchesSelector(t){return this.selectors.some((e=>t.matches(e)))}destroy(){this.observer&&(this.observer.disconnect(),h.i("AdFilter","观察器已销毁"))}}var d=n((function(t){var e=Object.prototype.hasOwnProperty,n="~";function r(){}function i(t,e,n){this.fn=t,this.context=e,this.once=n||!1}function o(t,e,r,o,s){if("function"!=typeof r)throw new TypeError("The listener must be a function");var a=new i(r,o||t,s),c=n?n+e:e;return t._events[c]?t._events[c].fn?t._events[c]=[t._events[c],a]:t._events[c].push(a):(t._events[c]=a,t._eventsCount++),t}function s(t,e){0==--t._eventsCount?t._events=new r:delete t._events[e]}function a(){this._events=new r,this._eventsCount=0}Object.create&&(r.prototype=Object.create(null),(new r).__proto__||(n=!1)),a.prototype.eventNames=function(){var t,r,i=[];if(0===this._eventsCount)return i;for(r in t=this._events)e.call(t,r)&&i.push(n?r.slice(1):r);return Object.getOwnPropertySymbols?i.concat(Object.getOwnPropertySymbols(t)):i},a.prototype.listeners=function(t){var e=n?n+t:t,r=this._events[e];if(!r)return[];if(r.fn)return[r.fn];for(var i=0,o=r.length,s=new Array(o);i<o;i++)s[i]=r[i].fn;return s},a.prototype.listenerCount=function(t){var e=n?n+t:t,r=this._events[e];return r?r.fn?1:r.length:0},a.prototype.emit=function(t,e,r,i,o,s){var a=n?n+t:t;if(!this._events[a])return!1;var c,u,f=this._events[a],h=arguments.length;if(f.fn){switch(f.once&&this.removeListener(t,f.fn,void 0,!0),h){case 1:return f.fn.call(f.context),!0;case 2:return f.fn.call(f.context,e),!0;case 3:return f.fn.call(f.context,e,r),!0;case 4:return f.fn.call(f.context,e,r,i),!0;case 5:return f.fn.call(f.context,e,r,i,o),!0;case 6:return f.fn.call(f.context,e,r,i,o,s),!0}for(u=1,c=new Array(h-1);u<h;u++)c[u-1]=arguments[u];f.fn.apply(f.context,c)}else{var l,d=f.length;for(u=0;u<d;u++)switch(f[u].once&&this.removeListener(t,f[u].fn,void 0,!0),h){case 1:f[u].fn.call(f[u].context);break;case 2:f[u].fn.call(f[u].context,e);break;case 3:f[u].fn.call(f[u].context,e,r);break;case 4:f[u].fn.call(f[u].context,e,r,i);break;default:if(!c)for(l=1,c=new Array(h-1);l<h;l++)c[l-1]=arguments[l];f[u].fn.apply(f[u].context,c)}}return!0},a.prototype.on=function(t,e,n){return o(this,t,e,n,!1)},a.prototype.once=function(t,e,n){return o(this,t,e,n,!0)},a.prototype.removeListener=function(t,e,r,i){var o=n?n+t:t;if(!this._events[o])return this;if(!e)return s(this,o),this;var a=this._events[o];if(a.fn)a.fn!==e||i&&!a.once||r&&a.context!==r||s(this,o);else{for(var c=0,u=[],f=a.length;c<f;c++)(a[c].fn!==e||i&&!a[c].once||r&&a[c].context!==r)&&u.push(a[c]);u.length?this._events[o]=1===u.length?u[0]:u:s(this,o)}return this},a.prototype.removeAllListeners=function(t){var e;return t?(e=n?n+t:t,this._events[e]&&s(this,e)):(this._events=new r,this._eventsCount=0),this},a.prototype.off=a.prototype.removeListener,a.prototype.addListener=a.prototype.on,a.prefixed=n,a.EventEmitter=a,t.exports=a}));const p={ROUTE_CHANGE:"route:change",ROUTE_BEFORE_CHANGE:"route:beforeChange",VIDEO_READY:"video:ready",VIDEO_ERROR:"video:error",VIDEO_STATE_CHANGE:"video:stateChange",SYNC_DATA:"sync:data",SYNC_VARIANT_DATA:"sync:variant:data",SYNC_CHAPTER_DATA:"sync:chapter:data",SYNC_STATE_DATA:"sync:state:data",VIDEO_VARIANT_CHANGER:"video:variant:change",VIDEO_CHAPTER_CHANGER:"video:chapter:change",AD_DETECTED:"ad:detected",AD_BLOCKED:"ad:blocked"},v=new d,g={pushState:History.prototype.pushState,replaceState:History.prototype.replaceState};class y extends i{#s=null;#a=new Map;constructor(t){super(),this.#s=new URL(location.href),h.i("RouteObserver","Initialized"),this.init()}init(){this.isInit||(this.#c(),this.#u(),this.isInit=!0,h.i("RouteObserver","Started"))}#c(){const t=t=>e=>{const n=new URL(location.href);if(this.#s.href===n.href)return;const r=this.#s;this.#s=n,this.#f(t,r,n)};this.#a.set("popstate",t("popstate")).set("hashchange",t("hashchange"));for(const[t,e]of this.#a)window.addEventListener(t,e)}#u(){const t=(t,e)=>(...n)=>{const r=this.#s.href,i=g[t].apply(history,n);return this.#f(e,r,new URL(location.href)),i};history.pushState=t("pushState","push"),history.replaceState=t("replaceState","replace")}#f(t,e,n){const r={path:e.pathname!==n.pathname,hash:e.hash!==n.hash,query:e.search!==n.search};if(Object.values(r).some(Boolean))try{v.emit(p.ROUTE_CHANGE,{oldUrl:e.href,newUrl:n.href,trigger:t,...r})}catch(t){h.e("RouteObserver",`Event emit failed: ${t.message}`)}}destroy(){if(this.isInit){for(const[t,e]of this.#a)window.removeEventListener(t,e);History.prototype.pushState=g.pushState,History.prototype.replaceState=g.replaceState,this.#a.clear(),this.isInit=!1,h.i("RouteObserver","Stopped")}}}const m=new e;m.RouteObserver=y,m.VideoVariant=class{constructor({label:t,desc:e=null,level:n=-1,options:r={}}){if("string"!=typeof t)throw new TypeError("label 必须是字符串类型");this.label=t,this.desc=e,this.level=Number(n),this.options=Object.freeze({...r}),Object.freeze(this)}},m.VideoChapter=class{constructor({label:t,options:e={}}){if("string"!=typeof t)throw new TypeError("label 必须是字符串类型");this.label=t,this.options=Object.freeze({...e}),Object.freeze(this)}},m.VideoPlayState=class{constructor({currentChapter:t,currentVariant:e,options:n={}}){if(t<0)throw new RangeError("剧集索引不能小于0");if(e<0)throw new RangeError("播放线路索引不能小于0");this.currentChapter=t,this.currentVariant=e,this.options=Object.freeze({...n}),Object.freeze(this)}},m.VideoInfo=class{constructor({videoId:t,title:e,cover:n="",desc:r=""}){if("string"!=typeof e)throw new TypeError("title 必须是字符串类型");this.videoId=t,this.title=e,this.cover=n,this.desc=r,Object.freeze(this)}getDefaultVariant(){return[...this.variants].sort(((t,e)=>e.level-t.level))[0]||null}},m.AdFilter=l,m.VideoSniffer=t,m.dispatcher=v,m.Log=h,m.fn=u,m.Events=p,m.$=r,m.enableVideoSniffer=(e,n)=>{const r=new t(m,e);return"function"==typeof n&&n(r),m.videoSniffer(r),r},m.enableAdFilter=(t,e)=>{const n=new l(m,t);return"function"==typeof e&&e(n),n},m.enableRouteObserver=(t,e)=>{const n=new y(m);return"function"==typeof e&&e(n),n},m.initDefaultSniffer(),window.snv=m,h.i("snv","初始化")}();
!function(){"use strict";class e{constructor(e){this.snv=e,this.RouteObserver=e.RouteObserver,this.VideoVariant=e.VideoVariant,this.VideoChapter=e.VideoChapter,this.VideoPlayState=e.VideoPlayState,this.VideoInfo=e.VideoInfo,this.AdFilter=e.AdFilter,this.VideoSniffer=e.VideoSniffer,this.dispatcher=e.dispatcher,this.Log=e.Log,this.fn=e.fn,this.Events=e.Events,this.$=e.$}}class t extends e{constructor(e){super(e),this.selector={episodeItem:".episode-item",activeEpisode:".episode-item-active"},this._stepEvents()}_stepEvents(){[this.Events.SYNC_DATA,this.Events.SYNC_CHAPTER_DATA].forEach((e=>{this.dispatcher.on(e,(()=>this._syncChapters()))}))}_syncChapters(){try{const e=this.snv.getChapters();this.snv.syncChapters(e),this.Log.i("duse","剧集数据同步成功")}catch(e){this.Log.e("duse",`同步剧集数据失败: ${e.message}`)}}fetchChapters(){this.Log.i("duse","开始嗅探剧集信息");const e=this.$(this.selector.episodeItem);if(0===e.length)return this.Log.w("duse","未找到剧集元素"),[];const t=e.map(((e,t)=>this._createChapter(t,e))).get().filter((e=>null!==e));return this.Log.i("duse","共嗅探到 "+t.length+" 个剧集信息"),t}_createChapter(e,t){try{return new this.VideoChapter({label:e.innerText.trim()||`${t+1}`})}catch(e){return this.Log.e("duse",`创建剧集失败: ${e.message}`),null}}switchChapter(e){return this.Log.i("duse",`切换剧集到索引 ${e}`),this.$(this.selector.episodeItem).eq(e).trigger("click"),!0}getActiveIndex(){const e=this.$(this.selector.episodeItem).index(this.selector.activeEpisode);return this.Log.i("duse","当前剧集: "+e),e}}class s extends e{constructor(e){super(e),this.selector={sourceItem:".source-item",activeSourceItem:".source-item-active"},this._stepEvents()}_stepEvents(){[this.Events.SYNC_DATA,this.Events.SYNC_VARIANT_DATA].forEach((e=>{this.dispatcher.on(e,(()=>this._syncVariants()))}))}_syncVariants(){try{const e=this.snv.getVariants();this.snv.syncVariants(e),this.Log.i("duse","视频线路同步成功")}catch(e){this.Log.e("duse",`同步线路数据失败: ${e.message}`)}}fetchVariants(){this.Log.i("duse","开始嗅探线路信息");const e=this.$(this.selector.sourceItem);if(0===e.length)return this.Log.w("duse","未找到线路元素"),[];const t=e.map(((e,t)=>{const s=this.$(t);return this._createVariant(s,e)})).get().filter((e=>null!==e));return this.Log.i("duse","共嗅探到 "+t.length+" 个线路信息"),t}_createVariant(e,t){try{const s=e.find(".name").text(),i=e.find(".count").text(),n=e.find(".tag").text();return new this.VideoVariant({label:s||`线路${t+1}`,desc:i||"自动检测",level:this._calcLevel(s,n)})}catch(e){return this.Log.e("duse",`创建线路失败: ${e.message}`),null}}_calcLevel(e,t){return t.includes("1080")?0:t.includes("蓝光")||e.includes("蓝光")||e.includes("优质")?1:-1}switchVariant(e){return this.Log.i("duse",`切换线路到索引 ${e}`),this.$(this.selector.sourceItem).eq(e).trigger("click"),!0}getActiveIndex(){const e=this.$(this.selector.sourceItem).index(this.selector.activeSourceItem);return this.Log.i("duse","当前线路: "+e),e}}class i extends e{constructor(e){super(e),this._stepEvents()}_stepEvents(){[this.Events.SYNC_DATA,this.Events.SYNC_STATE_DATA].forEach((e=>{this.dispatcher.on(e,(()=>this._syncVideoState()))})),this.dispatcher.on(this.Events.ROUTE_CHANGE,(async e=>{this.Log.i("duse","路由切换了::"+JSON.stringify(e));let t=this.isOnPlayPage();this._isReseted||t?t&&(this._isReseted=!1):(this.Log.i("duse","执行影视数据重置"),this._isReseted=!0,this.snv.reset())}))}_syncVideoState(){try{const e=this.snv.getPlayState();this.snv.syncPlayState(e),this.Log.i("duse","播放状态数据同步成功")}catch(e){this.Log.e("duse",`同步播放状态失败: ${e.message}`)}}fetchVideoState(e,t){if(this.Log.i("duse","开始嗅探当前播放状态, isOnPlayPage="+this.isOnPlayPage()),!this.isOnPlayPage())return snv.Log.w("duse","当前不在播放页，返回空状态"),null;const s=new this.VideoPlayState({currentChapter:t.getActiveIndex(),currentVariant:e.getActiveIndex(),options:{title:this.$(".title-box").text()}});return snv.Log.i("duse","播放状态信息: "+JSON.stringify(s)),s}isOnPlayPage(){return window.location.hash.includes("/vod/detail?vodId=")}}!function(e){if(!e.fn.matchesHostname(/a\.duse/))return;const n=new s(e),r=new t(e),h=new i(e);e.enableVideoSniffer({fetchVariants:()=>n.fetchVariants(),fetchChapters:()=>r.fetchChapters(),fetchPlayState:()=>h.fetchVideoState(n,r),checkIsPlayPage:()=>h.isOnPlayPage(),onSwitchVariant:e=>n.switchVariant(e),onSwitchChapter:e=>r.switchChapter(e)},(t=>{e.Log.i("duse","enabled sniffer")})),e.enableRouteObserver({}),e.enableAdFilter({selectors:[".entra-box",".van-col",".app-recommend",".guide"],onDetect:t=>{const s=e.$(t);if(s.hasClass("app-recommend")||s.hasClass("guide"))s.hide();else{const e=s.text()||"";!s.hasClass("fs-margin")&&e.includes("应用")&&s.hide()}}})}(snv)}();
''';

final _initialUserScripts = UnmodifiableListView<UserScript>([
  UserScript(
    source: snifferScript,
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
  ),
]);

//屏幕旋转时，保持WebView实例不重新加载

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {

  //屏幕旋转时，保持WebView实例不重新加载
  static final _keepAlive = InAppWebViewKeepAlive();

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      keepAlive: _keepAlive,
      initialUserScripts: _initialUserScripts,
      initialUrlRequest: URLRequest(url: WebUri("https://m.baidu.com")),
      initialSettings: InAppWebViewSettings(
        isInspectable: true,
        useShouldInterceptRequest: true,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        iframeAllow: "camera; microphone",
        iframeAllowFullscreen: true,
        javaScriptEnabled: true,
        transparentBackground: true,
        cacheEnabled: true,
        domStorageEnabled: true,
        useHybridComposition: true,
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async{
        final scheme = navigationAction.request.url?.scheme;
        if(scheme == null){
          return NavigationActionPolicy.ALLOW;
        }
        if (![
          "http",
          "https",
        ].contains(scheme)) {
        return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}

class WalletPage extends StatelessWidget {
  WalletPage({Key? key}) : super(key: key);

  final WalletController controller = Get.put(WalletController());
  final WalletState state = Get.find<WalletController>().state;


// 站点抽屉菜单，包含导航功能
  Widget buildDrawer({
    required BuildContext context,
  }) {
    return Drawer(
      child: Container(
        color: Colors.grey[850],
        child: Column(
          children: [
            // 抽屉头部
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.grey[900],
              child: Container(
                height: 48.0,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  "站点切换",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // 站点列表
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children:
                sites.map((site) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: site.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                      title: Text(
                        site.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: site.statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          site.statusText,
                          style: TextStyle(
                            color: site.statusColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // 底部导航功能栏
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: "后退",
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: "刷新",
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: "前进",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Global.text.appName),
        actions: [buildLanguageSwitch()],
      ),
      drawer: buildDrawer(context: context),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 50,
      body: WebView(),
      // body: Container(
      //   padding: XEdgeInsets(horizontal: 24, bottom: 56),
      //   alignment: Alignment.center,
      //   child: Column(
      //     children: [
      //       const Spacer(flex: 2),
      //       Text('开始进入 Web3.0', style: Get.textTheme.headlineMedium),
      //       Padding(
      //         padding: XEdgeInsets(top: 24),
      //         child: Text(
      //           '安全的去中心化钱包，为用户的交昜保驾护航，保证用户可安心畅游 Web3 世界',
      //           textAlign: TextAlign.center,
      //           style: Get.textTheme.bodyLarge?.copyWith(
      //             color: Colors.black54,
      //           ),
      //         ),
      //       ),
      //       const Spacer(flex: 1),
      //       FilledButton(
      //         style: FilledButton.styleFrom(minimumSize: Size.fromHeight(40)),
      //         onPressed: () {
      //           Get.toNamed(kCreateWalletPage);
      //         },
      //         child: Text(Global.text.createWallet),
      //       ),
      //       Padding(
      //         padding: const XEdgeInsets(top: 16),
      //         child: OutlinedButton(
      //           style:
      //               OutlinedButton.styleFrom(minimumSize: Size.fromHeight(40)),
      //           onPressed: () {
      //             Get.toNamed(kImportWalletPage);
      //           },
      //           child: Text(Global.text.importWallet),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget buildLanguageSwitch() {
    return Padding(
      padding: XEdgeInsets(right: 16),
      child: DropdownMenu<AppLanguageEnum>(
        initialSelection: controller.language,
        dropdownMenuEntries: AppLanguageEnum.values.map((element) {
          return DropdownMenuEntry(label: element.label, value: element);
        }).toList(),
        onSelected: controller.changeLanguage,
      ),
    );
  }
}
