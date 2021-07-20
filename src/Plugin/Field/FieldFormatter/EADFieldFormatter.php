<?php

namespace Drupal\ead\Plugin\Field\FieldFormatter;

use Drupal\Core\Field\FieldItemInterface;
use Drupal\Core\Field\FieldItemListInterface;
use Drupal\Core\Field\FormatterBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\file\Entity\File;

/**
 * Plugin implementation of the 'eadfield_formatter' formatter.
 *
 * @FieldFormatter(
 *   id = "eadfield_formatter",
 *   label = @Translation("EAD Field formatter"),
 *   field_types = {
 *     "file"
 *   }
 * )
 */
class EADFieldFormatter extends FormatterBase {

  /**
   * {@inheritdoc}
   */
  public static function defaultSettings() {
    return [
        // Implement default settings.
      ] + parent::defaultSettings();
  }

  /**
   * {@inheritdoc}
   */
  public function settingsForm(array $form, FormStateInterface $form_state) {
    return [
        // Implement settings form.
      ] + parent::settingsForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function settingsSummary() {
    $summary = [];
    // Implement settings summary.

    return $summary;
  }

  /**
   * {@inheritdoc}
   */
  public function viewElements(FieldItemListInterface $items, $langcode) {
    $elements = [];

    foreach ($items as $delta => $item) {
      $elements[$delta] = ['#markup' => $this->viewValue($item)];
    }
    $theme = [
      '#theme' => 'ead',
      '#html' => $elements,

    ];

    return $theme;
  }

  /**
   * Generate the output appropriate for one field item.
   *
   * @param \Drupal\Core\Field\FieldItemInterface $item
   *   One field item.
   *
   * @return string
   *   The textual output generated.
   *   The textual output generated.
   */
  protected function viewValue(FieldItemInterface $item) {
    global $base_url;
    $path = drupal_get_path('module', 'ead');
    $fileItem = $item->getValue();
    // Create XML file
    $xml = new \DOMDocument();
    $xml->load(File::load($fileItem['target_id'])->getFileUri());
    //Create XSLT
    $xslt = new \XSLTProcessor();
    // Import Stylesheet
    $xsl = new \DOMDocument();

    $xsl->load("$base_url/$path/data/eadcbs5.xsl");
    $xslt->importStyleSheet($xsl);
    return $xslt->transformToXML($xml);
  }

}
