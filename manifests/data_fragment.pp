define concat::data_fragment (
  String $target,
  Any $data = $title,
  String $order = '10',
) {
  concat_data_fragment { $title:
    target => $target,
    data   => $data,
    order  => $order,
  }
}
