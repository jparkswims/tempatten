function h = errorbar2(X,Y,L,U,L2,U2,markerShape,markerColor,colorVec,lineWidth,capSize)

capSize = capSize/100;

plot([X X],[L+Y U+Y],'color',colorVec,'LineWidth',lineWidth)
plot([X-capSize X+capSize],[L+Y L+Y],'color',colorVec,'LineWidth',lineWidth)
plot([X-capSize X+capSize],[U+Y U+Y],'color',colorVec,'LineWidth',lineWidth)
if ~isempty(L2)
    plot([X X],[L2+Y U2+Y],'color',[0 0 0],'LineWidth',lineWidth*2)
end
h = plot(X,Y,markerShape,'color',colorVec,'MarkerFaceColor',markerColor,'MarkerSize',8);
