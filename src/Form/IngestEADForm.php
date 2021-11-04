<?php

namespace Drupal\ead\Form;

use Drupal\Core\Archiver\ArchiverException;
use Drupal\Core\Archiver\Zip;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\file\Entity\File;
use Drupal\node\Entity\Node;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Class IngestEADForm.
 */
class IngestEADForm extends FormBase {

  /**
   * Drupal\Core\Entity\EntityManagerInterface definition.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityTypeManager;

  protected $fileSystem;

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    $instance = parent::create($container);
    $instance->entityTypeManager = $container->get('entity_type.manager');
    $instance->fileSystem = $container->get('file_system');
    return $instance;
  }

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'ingest_ead_form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $term = $this->entityTypeManager->getStorage('taxonomy_term')
      ->loadByProperties(['name' => 'Collection', 'vid' => 'islandora_models']);
    $term = reset($term);
    $properties = [
      'type' => 'islandora_object',
      'field_model' => $term->id(),
      'status' => 1,
    ];

    $nodes = $this->entityTypeManager->getStorage('node')
      ->loadByProperties($properties);
    $options = [];
    foreach ($nodes as $node) {
      $options[$node->id()] = $node->label();
    }
    $form['collection'] = [
      '#type' => 'select',
      '#title' => $this->t('Collection'),
      '#description' => $this->t('Enter collection to which these EADs will be added'),
      '#options' => $options,
      '#weight' => '0',
    ];
    $form['ead_files'] = [
      '#type' => 'managed_file',
      '#title' => $this->t('EAD Files'),
      '#description' => $this->t('Upload zipped EAD file'),
      '#upload_location' => 'public://csvs',
      '#upload_validators' => [
        'file_validate_extensions' => ['zip'],
      ],
      '#weight' => '0',
    ];
    $form['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Submit'),
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    foreach ($form_state->getValues() as $key => $value) {
      // @TODO: Validate fields.
    }
    parent::validateForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $values = $form_state->getValues();
    $fid = $values['ead_files'][0];
    $file = File::load($fid);
    $path = $file->getFileUri();
    $tmp = 'public://csvs/tmp';
    $realpath = $this->fileSystem->realpath($path);
    $destination = $this->fileSystem->realpath($tmp);


    try {
      $zip = new Zip($realpath);
      $zip->extract($destination);
      $files = $zip->listContents();
      $zip->remove($file);
    } catch (ArchiverException $exception) {
      watchdog_exception('ead', $exception);
      // Some code if the error of unzip will happen.
    }
    $cleaned = \array_filter($files, function ($k) {
      if (substr($k, 0, 8) == '__MACOSX' || \explode('.', $k)[1] != \strtolower('xml')) {
        return FALSE;
      }
      return TRUE;
    });

    foreach ($cleaned as $candidate) {
      $source = "$tmp/$candidate";
      $dest = 'public://eads1';
      $contents = \file_get_contents($source);
      $file_parts = [
        'filename' => $candidate,
        'uri' => "$dest/$candidate",
        'status' => 1,
      ];
      $ead_file = File::create($file_parts);
      $ead_file->save();
      $dir = dirname($ead_file->getFileUri());
      if (!file_exists($dir)) {
        mkdir($dir, 0770, TRUE);
      }
      \file_put_contents($ead_file->getFileUri(), $contents);
      $ead_file->save();
      $new_ead = Node::create(['type' => 'ead_finding_aid']);
      $new_ead->set('title', 'PlaceHolder');
      $new_ead->set('field_ead', $ead_file->id());
      $new_ead->set('field_member_of', $values['collection']);
      $new_ead->enforceIsNew();
      $new_ead->save();
    }
    $this->fileSystem->deleteRecursive($tmp);
    $file->delete();
    \Drupal::messenger()->addStatus(count($cleaned) . "EAD records created");
  }
}
