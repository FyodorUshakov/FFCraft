# -*- coding: utf-8 -*-
"""生成 ffmpeg 转换器应用图标：淡蓝渐变圆角方块 + 胶片 + 播放三角。"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
ICO_PATH = ROOT / "windows" / "runner" / "resources" / "app_icon.ico"
PNG_PATH = ROOT / "windows" / "runner" / "resources" / "app_icon.png"

SIZE = 512
SS = 4  # 超采样倍数


def lerp(a, b, t):
    return tuple(round(a[i] + (b[i] - a[i]) * t) for i in range(3))


def main():
    big = SIZE * SS
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # 背景：淡蓝到深蓝的渐变（圆角矩形）
    top = (79, 195, 247)    # #4FC3F7
    bottom = (2, 136, 209)  # #0288D1
    margin = 28 * SS
    radius = 110 * SS
    rect = [margin, margin, big - margin, big - margin]
    for y in range(rect[1], rect[3], 4):
        t = (y - rect[1]) / (rect[3] - rect[1])
        color = lerp(top, bottom, t)
        d.rounded_rectangle(
            [rect[0], y, rect[2], min(y + 5, rect[3])],
            radius=radius,
            fill=color + (255,),
        )

    # 顶部高光
    glow = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse(
        [rect[0] - 90 * SS, rect[1] - 140 * SS, rect[2] + 90 * SS, rect[1] + 160 * SS],
        fill=(255, 255, 255, 72),
    )
    glow = glow.filter(ImageFilter.GaussianBlur(40 * SS))
    img = Image.alpha_composite(img, glow)
    d = ImageDraw.Draw(img)

    # 胶片条（左侧竖条 + 孔洞）
    film_x = 108 * SS
    film_y = 88 * SS
    film_w = 92 * SS
    film_h = 336 * SS
    d.rounded_rectangle([film_x, film_y, film_x + film_w, film_y + film_h], radius=18 * SS, fill=(255, 255, 255, 255))
    hole_r = 9 * SS
    for hy in range(film_y + 24 * SS, film_y + film_h - 20 * SS, 52 * SS):
        for hx in (film_x + 20 * SS, film_x + film_w - 20 * SS):
            d.ellipse([hx - hole_r, hy - hole_r, hx + hole_r, hy + hole_r], fill=(2, 136, 209, 255))

    # 播放三角（右侧）
    cx, cy = 300 * SS, 256 * SS
    r = 118 * SS
    d.polygon(
        [
            (cx - int(r * 0.55), cy - r),
            (cx - int(r * 0.55), cy + r),
            (cx + int(r * 0.85), cy),
        ],
        fill=(255, 255, 255, 255),
    )

    # 柔和投影
    shadow = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle(rect, radius=radius, fill=(0, 0, 0, 90))
    shadow = shadow.filter(ImageFilter.GaussianBlur(24 * SS))
    mask = Image.new("L", (big, big), 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle(rect, radius=radius, fill=255)
    img = Image.composite(img, shadow, mask)

    img = img.resize((SIZE, SIZE), Image.LANCZOS)

    ICO_PATH.parent.mkdir(parents=True, exist_ok=True)
    img.save(PNG_PATH)
    img.save(
        ICO_PATH,
        sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
    )
    print(f"wrote {ICO_PATH}")
    print(f"wrote {PNG_PATH}")


if __name__ == "__main__":
    main()
