enum SliderItems { warmUp, work, rest, coolDown, setCount, }

class SliderItem{
  const SliderItem({
    this.item,
    this.textDescription,
    this.divisions,
    this.maxValue,
    this.isDuration = true,
  });

  final SliderItems item;
  final String textDescription;
  final int divisions;
  final double maxValue;
  final bool isDuration;
}