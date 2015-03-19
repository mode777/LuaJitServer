<?lua
    UseLayout("/views/_layout/layout.lsp")
    local p=print
    p("<ul>")
    for _,link in ipairs(myData) do
        p("<li><a href='"..link.href.."'>"..link.text.."</a></li>")
    end
    p("</ul>")
?>
<p>Username: <?lua p(username) ?></p>
