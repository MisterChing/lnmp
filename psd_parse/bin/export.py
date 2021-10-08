# -*- coding: utf-8 -*-

import json
import sys
import os
from urllib.parse import urlparse
from psd_tools import PSDImage

sys.path.append('..')
from extract.effects import EffectsExtract
from extract.font import FrontAttr

psdPath = sys.argv[1]
pathInfo = urlparse(psdPath)
realPath = os.path.realpath(pathInfo.path)
psdIns = PSDImage.open(realPath)
layerList = []

for layer in reversed(list(psdIns.descendants())):
    if layer.width == 0 or layer.height == 0:
        continue
    # print(layer.name)
    # if layer.name != 'font_css':
    #     continue
    tmpLayer = {}
    tmpLayer['name'] = layer.name
    tmpLayer['size'] = layer.size
    tmpLayer['width'] = layer.width
    tmpLayer['height'] = layer.height
    tmpLayer['bbox'] = layer.bbox
    tmpLayer['left'] = layer.left
    tmpLayer['top'] = layer.top
    tmpLayer['right'] = layer.right
    tmpLayer['bottom'] = layer.bottom
    tmpLayer['offset'] = layer.offset
    tmpLayer['kind'] = layer.kind
    tmpLayer['is_group'] = layer.is_group()
    tmpLayer['has_effects'] = layer.has_effects()
    tmpLayer['effects_info'] = EffectsExtract(layer).parse()
    tmpLayer['has_stroke'] = layer.has_stroke()
    tmpLayer['opacity'] = layer.opacity
    viewPort = dict()
    viewPort['left'] = 0 if layer.left < 0 else layer.left
    viewPort['top'] = 0 if layer.top < 0 else layer.top
    viewPort['right'] = psdIns.width if psdIns.width < layer.width + layer.left else layer.width + layer.left
    viewPort['bottom'] = psdIns.height if psdIns.height < layer.height + layer.top else layer.height + layer.top
    tmpLayer['view_port'] = tuple(viewPort.values())

    if layer.kind == 'type':
        tmpLayer['text'] = layer.text
        # 文本属性
        tmpLayer['text_attribute'] = FrontAttr(layer).parse()

    layerList.append(tmpLayer)

print(json.dumps(layerList, ensure_ascii=False))
