<%@ Page Language="C#" Inherits="Orchard.Mvc.ViewPage<ContentDetailsViewModel>" %>
<%@ Import Namespace="Orchard.DevTools.ViewModels"%>
<%@ Import Namespace="Orchard.ContentManagement"%>
<%@ Import Namespace="System.Reflection" %>
<h1><%: Html.TitleForPage(T("{0} Content Type", Model.Item.ContentItem.ContentType).ToString(), T("Content").ToString())%></h1>
<h2><%: T("Content Item")%></h2>
<p>
<%: T("Id:")%>
    <%=Model.Item.ContentItem.Id %><br />
<%: T("Version:")%>
    <%=Model.Item.ContentItem.Version %><br />
<%: T("ContentType:")%>
    <%=Model.Item.ContentItem.ContentType %><br />
<%: T("DisplayText:")%> 
    <%=Html.ItemDisplayText(Model.Item) %><br />
<%: T("Links:")%> 
    <%=Html.ItemDisplayLink(T("view").ToString(), Model.Item) %> <%=Html.ItemEditLink(T("edit").ToString(), Model.Item) %>
</p>
<h2><%: T("Content Item Parts")%></h2>
<ul>
    <%foreach (var partType in Model.PartTypes.OrderBy(x => x.Name)) {%>
    <li><span style="font-weight: bold;">
        <%if (partType.IsGenericType) {%><%: partType.Name +" "+partType.GetGenericArguments().First().Name %>
        <%: " (" + partType.GetGenericArguments().First().Namespace + ")" %><%}
          else {%><%: partType.Name %>
        <%:  " (" + partType.Namespace + ")" %><%
                                                            }
          
          %></span>
        <ul style="margin-left: 20px">
            <%foreach (var prop in partType.GetProperties().Where(x => x.DeclaringType == partType)) {
                  var value = prop.GetValue(Model.Locate(partType), null);%>
            <li style="font-weight: normal;">
                <%: prop.Name %>:
                <%: value %>
                <%var valueItem = value as ContentItem;
                  if (valueItem == null && value is IContent) {
                      valueItem = (value as IContent).ContentItem;
                  }
                  if (valueItem != null) {
                      %><%: Html.ActionLink(T("{0} #{1} v{2}", valueItem.ContentType, valueItem.Id, valueItem.Version).ToString(), "details", new { valueItem.Id }, new { })%><%
                  }
                  %>
                <ul style="margin-left: 20px">
                    <%if (value == null || prop.PropertyType.IsPrimitive || prop.PropertyType == typeof(string) || prop.PropertyType == typeof(DateTime?)) { }
                      else if (typeof(IEnumerable).IsAssignableFrom(prop.PropertyType)) {
                          foreach (var item in value as IEnumerable) {
                    %>
                    <li><%: item.GetType().Name %>:<%: item %></li>
                    <%
                        }

                      }
                      else {%>
                    <%foreach (var prop2 in value.GetType().GetProperties().Where(x => x.GetIndexParameters().Count() == 0)) {%>
                    <li>
                        <%: prop2.Name %>
                        <%: prop2.GetValue(value, null) %></li>
                    <%} %>
                    <%} %>
                </ul>
            </li>
            <%} %>
        </ul>
    </li>
    <%}%>
</ul>


<h3>Displays</h3>
<ul>
    <%foreach (var display in Model.Displays) {%>
    <li><span style="font-weight: bold">
        <%: display.Prefix %></span>
        <%: display.Model.GetType().Name %>
        (<%: display.Model.GetType().Namespace %>)
        Template:<%: display.TemplateName ?? "(null)" %>
        Prefix:<%: display.Prefix ?? "(null)" %>
        Zone:<%: display.ZoneName ?? "(null)" %>
        Position:<%: display.Position ?? "(null)" %>
        <div style="margin-left: 20px; border: solid 1px black;">
            <%: Html.DisplayFor(x => display.Model, display.TemplateName, display.Prefix)%>
        </div>
    </li>
    <%                      
        }%>
</ul>


<h3>Editors</h3>
<ul>
    <%foreach (var editor in Model.Editors) {%>
    <li><span style="font-weight: bold">
        <%: editor.Prefix %></span>
        <%: editor.Model.GetType().Name %>                    
        (<%: editor.Model.GetType().Namespace %>)
        Template:<%: editor.TemplateName ?? "(null)" %>
        Prefix:<%: editor.Prefix ?? "(null)" %>
        Zone:<%: editor.ZoneName ?? "(null)" %>
        Position:<%: editor.Position??"(null)" %>
        <div style="margin-left: 20px; border: solid 1px black;">
            <%: Html.EditorFor(x=>editor.Model, editor.TemplateName, editor.Prefix) %>
        </div>
    </li>
    <%                      
        }%>
</ul>
