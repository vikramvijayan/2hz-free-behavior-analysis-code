function saveallfigs(dir)

h = get(0,'children');
for i=1:length(h)
  %set(h(i),'Visible','on');
  saveas(h(i), [dir num2str(i)], 'fig');
  saveas(h(i), [dir num2str(i)], 'png');
  delete(h(i));
end