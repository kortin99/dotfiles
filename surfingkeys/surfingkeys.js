/*
 * Settings
 */
api.Hints.characters = 'yuiophjklnm';
settings.lurkingPattern = /https:\/\/github\.com|.*confluence.*/i;
settings.showModeStatus = false;
settings.clickableSelector = '';
settings.verticalTabs = true;


/*
 * 快捷键
 */

// 标签页跳转
api.map('gK', 'E')
api.map('gJ', 'R')
api.unmap('E')
api.unmap('R')

api.mapkey('yA', '#7复制当前页面链接', function() {
  const text = `${document.title}
${window.location.href}`;
  api.Clipboard.write(text);
});

// URL and clipboard operations
api.mapkey("ym", "#7复制当前页面链接 (Markdown 格式)", () =>
  api.Clipboard.write(`[${document.title}](${window.location.href})`),
);

api.mapkey('p', '#0进入短暂的 PassThrough 模式以暂时禁用 SurfingKeys', function() {
  api.Normal.passThrough(2000);
});

api.mapkey("P", "#0进入 PassThrough 模式以暂时禁用 SurfingKeys", () => {
  const TIMEOUT_LONG_MS = 300000;
  const seconds = TIMEOUT_LONG_MS / 1000;
  api.Front.showBanner(`进入 PassThrough 模式以暂时禁用 SurfingKeys，${seconds}秒后退出，按 ESC 可提前退出`, 1600);
  api.Normal.passThrough(TIMEOUT_LONG_MS);
});

/**
 * 搜索
 */

api.addSearchAlias('d', 'duckduckgo', 'https://duckduckgo.com/?q=', 's', 'https://duckduckgo.com/ac/?q=', function(response) {
  var res = JSON.parse(response.text);
  return res.map(function(r){
      return r.phrase;
  });
});

/**
 * 功能
 */

/*
 * Styles
 */

// api.Hints.style(
//   'border: solid 1px #3D3E3E; color:#F92660; background: initial; background-color: #272822; font-family: Maple Mono Freeze; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.8);',
// );
api.Hints.style(
  'border: solid 1px #3D3E3E !important; padding: 1px !important; color: #A6E22E !important; background: #272822 !important; font-family: Maple Mono Freeze !important; box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.8) !important;',
  'text',
);
api.Visual.style('marks', 'background-color: #A6E22E99;');
api.Visual.style('cursor', 'background-color: #F92660;');

/* set theme */
settings.theme = `
#sk_omnibar, #sk_status, #sk_tabs, #sk_keystroke, #sk_usage, #sk_popup, #sk_editor {
  --bg-color: #282828;
  --bg-active-color: #181818;
  --text-color: #d9dce0;
  --text-primary-color: #ebdbb2;
  --text-secondary-color: #38971a;

  /* shadow */
  --shadow-color: #000;
  --shadow-lg-opacity: 0.8;
  --shadow-md-opacity: 0.3;
  --shadow-sm-opacity: 0.2;
  --shadow-lg: 0px 30px 50px rgba(0, 0, 0, var(--shadow-lg-opacity));
  --shadow-md: 0px 10px 20px rgba(0, 0, 0, var(--shadow-md-opacity));
  --shadow-sm: 0px 5px 10px rgba(0, 0, 0, var(--shadow-sm-opacity));

  /* border */
  --divider-color: #3D3E3E;
  --border-radius: 8px;
}

.sk_theme {
    font-family: Maple Mono Freeze,Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: var(--bg-color);
    color: var(--text-primary-color);
}

.sk_theme input {
  color: var(--text-color);
}

.sk_theme tbody {
    color: #b8bb26;
}
.sk_theme .url {
    color: var(--text-secondary-color);
}
.sk_theme .annotation {
    color: #b16286;
}

#sk_omnibar {
    width: 60%;
    left:20%;
    box-shadow: var(--shadow-lg);
}

.sk_omnibar_middle {
	top: 15%;
	border-radius: 10px;
}

/*
 * 搜索区域
 */

#sk_omnibarSearchArea {
  border-bottom: 0px solid var(--bg-color);
  padding: 0;
  margin: 0.75rem 1rem;
}

#sk_omnibarSearchArea .prompt{
	color: #aaa;
	background-color: var(--bg-active-color);
	border-radius: var(--border-radius);
  padding: 4px 14px;
	font-weight: bold;
  font-size: 16px;
}

#sk_omnibarSearchArea > input {
	display: inline-block;
	width: 100%;
	flex: 1;
	font-size: 20px;
	margin-bottom: 0;
	padding: 0px 0px 0px 0.5rem;
	background: transparent;
	border-style: none;
	outline: none;
	padding-left: 18px;
  color: var(--text-color);
}


#sk_omnibarSearchArea .resultPage {
	display: inline-block;
  font-size: 10px;
	width: auto;
}

.sk_theme .omnibar_highlight {
    color: var(--text-primary-color);
}

.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: var(--bg-color);
}

.sk_theme #sk_omnibarSearchResult {
    max-height: 60vh;
    overflow: hidden;
    margin: 0rem 0rem;
}



#sk_omnibarSearchResult > ul {
	padding: 1.0em;
}

.sk_theme #sk_omnibarSearchResult ul li {
    padding: 6px 0.8rem;
    margin: 4px 0;
}

.sk_theme #sk_omnibarSearchResult ul li.focused {
	background: var(--bg-active-color);
	border-color: var(--bg-active-color);
	border-radius: var(--border-radius);
	position: relative;
	box-shadow: none;
}

#sk_omnibarSearchResult li div.title {
	text-align: left;
	max-width: 100%;
	white-space: nowrap;
	overflow: auto;
}

#sk_omnibarSearchResult li .icon {
  width: 20px;
  margin-right: 8px;
}





/**
 * 标签栏
 */

#sk_tabs {
	position: fixed;
	top: 50%;
	left: 50%;
  transform: translate(-50%, -50%);
  background: var(--bg-color);
	overflow: auto;
	z-index: 2147483000;
  box-shadow: var(--shadow-lg);
	margin-left: 1rem;
	margin-top: 1.5rem;
  border: solid 1px var(--bg-color);
  border-radius: 15px;
  padding: 10px;

}

#sk_tabs div.sk_tab {
	vertical-align: bottom;
	justify-items: center;
	border-radius: 0px;
  background: var(--bg-color);

	margin: 0px;
	box-shadow: 0px 0px 0px 0px rgba(245, 245, 0, 0.3);
	box-shadow: 0px 0px 0px 0px rgba(0, 0, 0, 0.8) !important;

	/* padding-top: 2px; */
	border-top: solid 0px var(--divider-color);
	margin-block: 0rem;
}

#sk_tabs .sk_tab_icon {
  margin-right: 4px;
}

#sk_tabs div.sk_tab:not(:has(.sk_tab_hint)) {
	background-color: var(--bg-color) !important;
	box-shadow: none !important;
	border: 1px solid var(--bg-color);
	border-radius: 20px;
	position: relative;
	z-index: 1;
	margin-left: 1.8rem;
	padding-left: 0rem;
	margin-right: 0.7rem;
}

#sk_tabs div.sk_tab_title {
	display: inline-block;
	vertical-align: middle;
	font-size: 10pt;
	white-space: nowrap;
	text-overflow: ellipsis;
	overflow: hidden;
	padding-left: 5px;
	color: var(--text-primary-color);
}

/*
#sk_tabs.vertical div.sk_tab_hint {
    position: inherit;
    left: 8pt;
    margin-top: 3px;
    border: solid 1px #3D3E3E; color:#F92660; background: initial; background-color: #272822; font-family: Maple Mono Freeze;
    box-shadow: 3px 3px 5px rgba(0, 0, 0, 0.8);
}

#sk_tabs.vertical div.sk_tab_wrap {
	display: inline-block;
	margin-left: 0pt;
	margin-top: 0px;
	padding-left: 15px;
}

#sk_tabs.vertical div.sk_tab_title {
	min-width: 100pt;
	max-width: 20vw;
}
*/




#sk_popup, #sk_editor {
	overflow: auto;
	position: fixed;
	width: 60%;
	max-height: 80%;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	text-align: left;
	box-shadow: var(--shadow-md);
	z-index: 2147483298;
	padding: 1rem;
	/* border: 1px solid var(--bg-color); */
	border-radius: var(--border-radius);
}

#sk_usage {
	overflow: auto;
	position: fixed;
	width: 80%;
	max-height: 80%;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	text-align: left;
	box-shadow: var(--shadow-md);
	z-index: 2147483298;
	padding: 1rem;
	border-radius: var(--border-radius);
  display: grid;
  grid-template-columns: 1fr 1fr;
  row-gap: 3rem;
}

#sk_keystroke {
	padding: 6px;
	position: fixed;
	float: right;
	bottom: 0px;
	z-index: 2147483000;
	right: 0px;
	background: var(--bg-color);
	color: #fff;
	border: 1px solid var(--bg-color);
	border-radius: 10px;
	margin-bottom: 1rem;
	margin-right: 1rem;
	box-shadow: var(--shadow-lg);
}

#sk_status {
	position: fixed;
	bottom: 20px;
	right: 20px;
	z-index: 2147483000;
	padding: 8px 8px 4px 8px;
	border-radius: var(--border-radius);
	border: 1px solid var(--bg-color);
	font-size: 12px;
	box-shadow: 10px 20px 20px 4px rgba(0, 0, 0, 0.8);
	/* margin-bottom: 1rem; */
	width: 20%;
}

/**
 * OmniBar
 */
.sk_theme .separator {
	color: #e8e8e8;
  font-size: 18px;
}

#sk_omnibarSearchResult {
  border-top: 1px solid var(--divider-color);
}

#sk_omnibarSearchResult li div.url {
	font-weight: normal;
	white-space: nowrap;
	color: #aaa;
}

.sk_theme .omnibar_highlight {
	color: #11eb11;
	font-weight: bold;
}

.sk_theme .omnibar_folder {
	border: 1px solid #188888;
	border-radius: var(--border-radius);
	background: #188888;
	color: var(--text-primary-color);
  margin-left: 0.5rem;
  padding: 2px 4px;
	/* box-shadow: 1px 1px 5px rgba(0, 8, 8, 1); */
}
.sk_theme .omnibar_timestamp {
	background: #cc4b9c;
	border: 1px solid #cc4b9c;
	border-radius: var(--border-radius);
	color: var(--text-primary-color);
  margin-left: 0.5rem;
  padding: 2px 4px;
	/* box-shadow: 1px 1px 5px rgb(0, 8, 8); */
}

#sk_status, #sk_find {
	font-size: 10pt;
	font-weight: bold;
    text-align: center;
    padding-right: 8px;
}


#sk_status span[style*="border-right: 1px solid rgb(153, 153, 153);"] {
    display: none;
}

`;
